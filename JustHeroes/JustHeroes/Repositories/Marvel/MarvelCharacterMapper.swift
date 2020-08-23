import Foundation

class MarvelCharacterMapper: CharactersRepositoryMapper {
    typealias DTO = MarvelDTO
    
    func map(fromObject object: MarvelDTO) -> [CharacterModel] {
        object.data.results.map { given -> CharacterModel in
            let characterModel = CharacterModel(name: given.name, description: given.description)
            characterModel.imageURL = getImageURL(
                withPath: given.thumbnail.path,
                ext: given.thumbnail.`extension`
            )
            return characterModel
        }
    }
    
    private func getImageURL(withPath path: String, ext: String) -> URL? {
        URL(string: "\(path)/portrait_fantastic.\(ext)")
    }
}
