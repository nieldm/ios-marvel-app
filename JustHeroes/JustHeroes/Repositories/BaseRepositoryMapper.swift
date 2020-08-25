import Foundation

protocol BaseRepositoryMapper {
    associatedtype DTO: Codable
    
    func map(fromObject object: DTO) -> [BaseModel]
}
