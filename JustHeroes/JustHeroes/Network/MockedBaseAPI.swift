import Foundation

enum MockFilesError: Error {
    case fileNotFound
}

private enum MockFiles: String {
    case characters
    case comics
    
    func loadDataFromFile() throws -> Data {
        let bundle = Bundle(for: MockedBaseAPI.self)
        guard let url = bundle.url(forResource: self.rawValue, withExtension: ".json") else {
            throw MockFilesError.fileNotFound
        }
        return try Data(contentsOf: url)
    }
}

class MockedBaseAPI: BaseAPIProtocol {
    let delay: Double
    
    init(delay: Double) {
        self.delay = delay
    }
    
    func request<T>(forPath path: String, method: HTTPMethod, withParameters parameters: Parameters, callback: @escaping (Result<T, Error>) -> Void) throws where T : Decodable {
        guard let mockFile = MockFiles(rawValue: path) else {
            fatalError("🚨 Missing mock for \(path)\nwith \(parameters)\nmethod \(method.rawValue)")
        }
        DispatchQueue.init(label: "delay", qos: .background).asyncAfter(deadline: .now() + self.delay) {
            self.processData(data: try? mockFile.loadDataFromFile(), callback: callback)
        }
    }
    
    func request<T>(forURLString urlString: String, method: HTTPMethod, withParameters parameters: Parameters, callback: @escaping (Result<T, Error>) -> Void) throws where T : Decodable {
        let path = String(urlString.split(separator: "/").last ?? "")
        try self.request(forPath: path, method: method, withParameters: parameters, callback: callback)
    }
}
