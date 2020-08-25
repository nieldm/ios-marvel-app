import Foundation

protocol BaseRepositoryDataSource {
    associatedtype DTO: Codable
    
    func fetch(
        withLimit limit: Int,
        offset: Int,
        sortedBy sort: SortOptions,
        withTerm term: String?,
        callback: @escaping (Result<DTO, Error>) -> Void
    )
}
