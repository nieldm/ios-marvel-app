import Foundation

struct MarvelCharacterDTO: Codable {}

class MarvelCharacterDataSource: CharactersRepositoryDataSource {
    
    typealias DTO = MarvelCharacterDTO
    
    static var apiKey: String? {
        ProcessInfo.processInfo.environment["MARVEL_API_KEY"]
    }
    
    enum Operation {
        case <#case#>
    }
    let urlString = "https://gateway.marvel.com:443/v1/public/characters?apikey=885d2218c82dce59c8159ef7d42823fe"
    
    func fetchCharacters(withLimit limit: Int, offset: Int, callback: @escaping (Result<MarvelCharacterDTO, Error>) -> Void) {
        
    }
    
}

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case GET
}

enum APIError: Error {
    case invalidURL
    case invalidComponents
}

class BaseAPI {
    
    let baseURL: URL
    
    init(baseURL: String) throws {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        self.baseURL = url
    }
    
    var defaultHeaders: [String: String] {
        [:]
    }
    
    func makeRequest(forPath path: String,
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
}
