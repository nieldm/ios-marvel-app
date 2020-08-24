import Foundation

class MarverlCharacterDataSource: MarvelDataSource, CharactersRepositoryDataSource {
    typealias DTO = MarvelDTO<MarvelCharacterDTO>
    
    func fetch(
        withLimit limit: Int,
        offset: Int,
        sortedBy sort: SortOptions,
        withTerm term: String?,
        callback: @escaping (Result<DTO, Error>) -> Void) {
        
        let queryConfig = MarvelOperationQueryConfig(
            limit: limit,
            offset: offset,
            sort: sort,
            term: term
        )
        
        let properties = MarvelOperation.character(query: queryConfig).properties
        do {
            try api.request(forPath: properties.path,
                        method: properties.method,
                        withParameters: properties.parameters) { (result: Result<DTO, Error>) in
                callback(result)
            }
        } catch {
            callback(.failure(error))
        }
    }
}
