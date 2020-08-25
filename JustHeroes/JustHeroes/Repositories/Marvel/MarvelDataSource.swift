import Foundation
import CryptoSwift

class MarvelDataSource {
    
    static var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["MARVEL_API_KEY"] else {
            fatalError("Missing api key at the enviroment")
        }
        return apiKey
    }
    
    static var privateKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["MARVEL_PRIVATE_KEY"] else {
            fatalError("Missing api key at the enviroment")
        }
        return apiKey
    }
    
    static let baseURL = "https://gateway.marvel.com:443/v1/public/"
    
    let api: BaseAPIProtocol
    
    init(api: BaseAPIProtocol) {
        self.api = api
    }
    
}
