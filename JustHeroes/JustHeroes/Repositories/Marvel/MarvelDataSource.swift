import Foundation
import CryptoSwift

class MarvelDataSource {
    
    static var apiKey: String {
        guard let apiKey = Assembler.shared.getMarvelAPIKey() else {
            fatalError("Missing api key at the enviroment")
        }
        return apiKey
    }
    
    static var privateKey: String {
        guard let apiKey = Assembler.shared.getMarvelAPIPrivateKey() else {
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
