import Foundation

extension SortOptions {
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

struct MarvelOperationQueryConfig {
    let limit: Int
    let offset: Int
    let sort: SortOptions?
    let term: String?
}

enum MarvelOperation {
    case character(query: MarvelOperationQueryConfig)
    case collection(url: String, query: MarvelOperationQueryConfig)
    
    var properties: (path: String, method: HTTPMethod, parameters: Parameters) {
        switch self {
        case .character(let query):
            let parameters = createParameters(
                withLimit: query.limit,
                offset: query.offset,
                sort: query.sort,
                term: query.term
            )
            
            return (path: "characters", method: .GET, parameters: parameters)
        case let .collection(url, query):
            let parameters = createParameters(
                withLimit: query.limit,
                offset: query.offset,
                sort: query.sort,
                term: query.term
            )

            return (path: url, method: .GET, parameters: parameters)
        }
    }
    
    private func createParameters(withLimit limit: Int, offset: Int, sort: SortOptions?, term: String?) -> Parameters {
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
        
        return parameters
    }
    
}
