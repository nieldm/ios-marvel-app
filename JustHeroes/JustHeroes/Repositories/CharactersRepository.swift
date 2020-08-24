import Foundation

typealias BaseResult = Result<[BaseModel], Error>

protocol CharactersRepositoryProtocol {
    func fetch(
        atPage page: Int,
        callback: @escaping (BaseResult) -> Void
    )
    
    func fetch(
        atPage page: Int,
        sortedBy sort: SortOptions,
        withTerm term: String?,
        callback: @escaping (BaseResult) -> Void
    )
}

protocol CharactersRepositoryDataSource {
    associatedtype DTO: Codable
    
    func fetch(
        withLimit limit: Int,
        offset: Int,
        sortedBy sort: SortOptions,
        withTerm term: String?,
        callback: @escaping (Result<DTO, Error>) -> Void
    )
}

protocol CharactersRepositoryMapper {
    associatedtype DTO: Codable
    
    func map(fromObject object: DTO) -> [BaseModel]
}

enum RepositoryError: Error {
    case loseContext
}

class CharactersRepository<DataSource: CharactersRepositoryDataSource, Mapper: CharactersRepositoryMapper>: CharactersRepositoryProtocol
    where DataSource.DTO == Mapper.DTO {
    
    let pageSize: Int
    let dataSource: DataSource
    let mapper: Mapper
    
    init(pageSize: Int,
         dataSource: DataSource,
         mapper: Mapper) {
        self.pageSize = pageSize
        self.dataSource = dataSource
        self.mapper = mapper
    }
    
    func fetch(atPage page: Int, callback: @escaping (BaseResult) -> Void) {
        self.fetch(atPage: page, sortedBy: .none, withTerm: nil, callback: callback)
    }
    
    func fetch(
        atPage page: Int,
        sortedBy sort: SortOptions,
        withTerm term: String?,
        callback: @escaping (BaseResult) -> Void) {
        dataSource.fetch(
            withLimit: pageSize,
            offset: pageSize * page,
            sortedBy: sort,
            withTerm: term) { [weak self] result in
                guard let strongSelf = self else {
                    callback(.failure(RepositoryError.loseContext))
                    return
                }
                do {
                    let characters = strongSelf.mapper.map(fromObject: try result.get())
                    callback(.success(characters))
                } catch {
                    callback(.failure(error))
                }
        }
    }
    
}
