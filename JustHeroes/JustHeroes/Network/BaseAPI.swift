import Foundation

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

protocol BaseAPIProtocol {
    func request<T: Decodable>(forPath path: String,
                               method: HTTPMethod,
                               withParameters parameters: Parameters,
                               callback: @escaping (Result<T, Error>) -> Void) throws
    func request<T: Decodable>(forURLString urlString: String,
                               method: HTTPMethod,
                               withParameters parameters: Parameters,
                               callback: @escaping (Result<T, Error>) -> Void) throws
}

class BaseAPI: BaseAPIProtocol {
    
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
    
    /// request with path using the baseURL
    /// - Parameters:
    ///   - path: path that will be added to the baseURL
    ///   - method: HTTPMethod
    ///   - parameters: HTTP headers
    ///   - callback: return a codable or an error in a Result
    /// - Throws: APIError
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
    
    /// request with the complete url
    /// - Parameters:
    ///   - urlString: complete url
    ///   - method: HTTPMethod
    ///   - parameters: HTTP headers
    ///   - callback: return a codable or an error in a Result
    /// - Throws: APIError
    func request<T: Decodable>(forURLString urlString: String,
                 method: HTTPMethod,
                 withParameters parameters: Parameters,
                 callback: @escaping (Result<T, Error>) -> Void) throws {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        let request = try makeRequest(forUrl: url, method: method, withParameters: parameters)
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
    
    private func makeRequest(forPath path: String,
                     method: HTTPMethod,
                     withParameters parameters: Parameters) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        return try makeRequest(forUrl: url, method: method, withParameters: parameters)
    }
    
    private func makeRequest(forUrl url: URL,
                     method: HTTPMethod,
                     withParameters parameters: Parameters) throws -> URLRequest {
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

extension BaseAPIProtocol {
    /// takes the data and try to convert into a Decodable object
    /// - Parameters:
    ///   - data: comming from the request
    ///   - callback: return a codable or an error in a Result
    func processData<T: Decodable>(data: Data?, callback: @escaping (Result<T, Error>) -> Void) {
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
    static func jsonObject<T: Decodable>(with data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
