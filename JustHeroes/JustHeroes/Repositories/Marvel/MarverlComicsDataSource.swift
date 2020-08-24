import Foundation

class MarverlComicsDataSource: MarvelDataSource, CharactersRepositoryDataSource {
    private let collectionURL: String
    
    init(collectionURL: String, api: BaseAPI) {
        self.collectionURL = collectionURL
        super.init(api: api)
    }
    
    typealias DTO = MarvelDTO<MarvelComicDTO>
    
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
        
        let properties = MarvelOperation.collection(url: self.collectionURL, query: queryConfig).properties
        do {
            try api.request(forURLString: properties.path,
                        method: properties.method,
                        withParameters: properties.parameters) { (result: Result<DTO, Error>) in
                callback(result)
            }
        } catch {
            callback(.failure(error))
        }
    }
}
