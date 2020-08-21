import Foundation

typealias CharacterResult = Result<[CharacterModel], Error>

protocol CharactersRepositoryProtocol {
    func fetchCharacters(
        atPage page: Int,
        callback: @escaping (CharacterResult) -> Void
    )
}

protocol CharactersRepositoryDataSource {
    associatedtype DTO: Codable
    
    func fetchCharacters(
        withLimit limit: Int,
        offset: Int,
        callback: @escaping (Result<DTO, Error>) -> Void
    )
}

protocol CharactersRepositoryMapper {
    associatedtype DTO: Codable
    
    func map(fromObject object: DTO) -> [CharacterModel]
}

enum RepositoryError: Error {
    case loseContext
}

class CharactersRepository<DataSource: CharactersRepositoryDataSource, Mapper: CharactersRepositoryMapper>: CharactersRepositoryProtocol where DataSource.DTO == Mapper.DTO {
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
    
    func fetchCharacters(atPage page: Int, callback: @escaping (CharacterResult) -> Void) {
        dataSource.fetchCharacters(withLimit: pageSize, offset: pageSize * page) { [weak self] result in
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
