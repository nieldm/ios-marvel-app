import Foundation
import CryptoSwift

private extension SortOptions {
    func toMarvelParameter() -> String? {
        switch self {
        case .dateAsc:
            return "modified"
        case .dateDesc:
            return "-modified"
        case .nameAsc:
            return "name"
        case .nameDesc:
            return "-name"
        case .none:
            return nil
        }
    }
}

class MarvelDataSource: CharactersRepositoryDataSource {
    typealias DTO = MarvelDTO
    
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
        case character(limit: Int, offset: Int, sort: SortOptions?, term: String?)
        
        var properties: (path: String, method: HTTPMethod, parameters: Parameters) {
            switch self {
            case .character(let limit, let offset, let sort, let term):
                let now = Date().timeIntervalSince1970
                
                var parameters: Parameters = [
                    "apikey": MarvelDataSource.apiKey,
                    "limit": limit,
                    "offset": offset,
                    "ts": now,
                    "hash": "\(now)\(MarvelDataSource.privateKey)\(MarvelDataSource.apiKey)".md5()
                ]
                
                if let sortBy = sort?.toMarvelParameter() {
                    parameters["orderBy"] = sortBy
                }
                
                if let term = term {
                    parameters["nameStartsWith"] = term
                }
                
                return (path: "characters", method: .GET, parameters: parameters)
            }
        }
    }
    
    let api: BaseAPI
    
    init(api: BaseAPI) {
        self.api = api
    }

    func fetchCharacters(
        withLimit limit: Int,
        offset: Int,
        sortedBy sort: SortOptions,
        withTerm term: String?,
        callback: @escaping (Result<MarvelDTO, Error>) -> Void) {
        let properties = Operation.character(limit: limit, offset: offset, sort: sort, term: term).properties
        do {
            try api.request(forPath: properties.path,
                        method: properties.method,
                        withParameters: properties.parameters) { (result: Result<MarvelDTO, Error>) in
                callback(result)
            }
        } catch {
            callback(.failure(error))
        }
    }
    
}
