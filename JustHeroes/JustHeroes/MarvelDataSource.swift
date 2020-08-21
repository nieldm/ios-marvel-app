import Foundation
import CryptoSwift

struct MarvelCharacterDTO: Codable {}

class MarvelDataSource: CharactersRepositoryDataSource {
    
    typealias DTO = MarvelCharacterDTO
    
    static var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["MARVEL_API_KEY"] else {
            fatalError("Missing api key at the enviroment")
        }
        return apiKey
    }
    
    static private var privateKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["MARVEL_PRIVATE_KEY"] else {
            fatalError("Missing api key at the enviroment")
        }
        return apiKey
    }
    
    static let baseURL = "https://gateway.marvel.com:443/v1/public/"
    
    enum Operation {
        case character(limit: Int, offset: Int)
        
        var properties: (path: String, method: HTTPMethod, parameters: Parameters) {
            switch self {
            case .character(let limit, let offset):
                let now = Date().timeIntervalSince1970
                
                let parameters: Parameters = [
                    "apikey": MarvelDataSource.apiKey,
                    "limit": limit,
                    "offset": offset,
                    "ts": now,
                    "hash": "\(now)\(MarvelDataSource.privateKey)\(MarvelDataSource.apiKey)".md5()
                ]
                return (path: "characters", method: .GET, parameters: parameters)
            }
        }
    }
    
    let api: BaseAPI
    
    init(api: BaseAPI) {
        self.api = api
    }
    
    func fetchCharacters(withLimit limit: Int, offset: Int, callback: @escaping (Result<MarvelCharacterDTO, Error>) -> Void) {
        let properties = Operation.character(limit: limit, offset: offset).properties
        do {
            try api.request(forPath: properties.path,
                        method: properties.method,
                        withParameters: properties.parameters) { (result: Result<MarvelCharacterDTO, Error>) in
                callback(result)
            }
        } catch {
            callback(.failure(error))
        }
    }
    
}

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case GET
}

enum APIError: Error {
    case invalidURL
    case invalidComponents
    case noData
    case unableToParse
}

class BaseAPI {
    
    let baseURL: URL
    let session: URLSession
    
    init(baseURL: String, session: URLSession) throws {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        self.baseURL = url
        self.session = session
    }
    
    var defaultHeaders: [String: String] {
        [:]
    }
    
    private func makeRequest(forPath path: String,
                     method: HTTPMethod,
                     withParameters parameters: Parameters) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch method {
        case .GET:
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw APIError.invalidComponents
            }
            components.queryItems = parameters
                .map { URLQueryItem(name: $0, value: String(describing: $1)) }
                .sorted { $0.name < $1.name }
            
            guard let urlWithComponents = components.url else {
                throw APIError.invalidComponents
            }
            
            request.url = urlWithComponents
        }
        request.allHTTPHeaderFields = defaultHeaders
        
        return request
    }
    
    func request<T: Decodable>(forPath path: String,
                 method: HTTPMethod,
                 withParameters parameters: Parameters,
                 callback: @escaping (Result<T, Error>) -> Void) throws {
        let request = try makeRequest(forPath: path, method: method, withParameters: parameters)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let error = error {
                return callback(.failure(error))
            }
            
            self?.processData(data: data, callback: callback)
            
            if let response = response, let data = data {
                URLCache.shared.storeCachedResponse(
                    CachedURLResponse(
                        response: response,
                        data: data),
                    for: request
                )
            }
        }
        URLCache.shared.getCachedResponse(for: task) { [weak self] (response) in
            guard let response = response else {
                return task.resume()
            }
            self?.processData(data: response.data, callback: callback)
        }
    }
    
    private func processData<T: Decodable>(data: Data?, callback: @escaping (Result<T, Error>) -> Void) {
        do {
            guard let data = data else {
                throw APIError.noData
            }
            let jsonObject: T = try JSONSerialization.jsonObject(with: data)
            return callback(.success(jsonObject))
        } catch {
            callback(.failure(error))
        }
    }
}

extension JSONSerialization {
    static func jsonObject<T>(with data: Data) throws -> T {
        guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? T else {
            throw APIError.unableToParse
        }
        return object
    }
}
