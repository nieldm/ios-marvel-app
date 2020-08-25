import Foundation

typealias BaseResult = Result<[BaseModel], Error>

enum RepositoryError: Error {
    case loseContext
}

protocol BaseRepositoryProtocol {
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

class BaseRepository<DataSource: BaseRepositoryDataSource, Mapper: BaseRepositoryMapper>: BaseRepositoryProtocol
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
        self.fetch(atPage: page, sortedBy: .dateDesc, withTerm: nil, callback: callback)
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
