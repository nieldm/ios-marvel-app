import Foundation

struct JHCharacter {}

typealias CharacterResult = Result<[JHCharacter], Error>

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
    func map<T: Codable>(fromObject object: T) -> [JHCharacter]
}

enum RepositoryError: Error {
    case loseContext
}

class CharactersRepository<DataSource: CharactersRepositoryDataSource>: CharactersRepositoryProtocol {
    let pageSize: Int
    let dataSource: DataSource
    let mapper: CharactersRepositoryMapper
    
    init(pageSize: Int,
         dataSource: DataSource,
         mapper: CharactersRepositoryMapper) {
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
