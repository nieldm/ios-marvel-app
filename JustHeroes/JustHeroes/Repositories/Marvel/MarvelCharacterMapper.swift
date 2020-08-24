import Foundation

private enum ImageResolution: String {
    case portraitFantastic = "/portrait_fantastic"
    case fullSize = ""
}

class MarvelCharacterMapper: CharactersRepositoryMapper {
    typealias DTO = MarvelDTO
    
    func map(fromObject object: MarvelDTO) -> [CharacterModel] {
        object.data.results.map { given -> CharacterModel in
            let characterModel = CharacterModel(
                name: given.name,
                description: given.description
            )
            characterModel.imageURL = getImageURL(
                withPath: given.thumbnail.path,
                ext: given.thumbnail.`extension`,
                resolution: .portraitFantastic
            )
            characterModel.highResImageURL = getImageURL(
                withPath: given.thumbnail.path,
                ext: given.thumbnail.`extension`,
                resolution: .fullSize
            )
            return characterModel
        }
    }
    
    private func getImageURL(withPath path: String, ext: String, resolution: ImageResolution) -> URL? {
        let urlString = "\(path)\(resolution.rawValue).\(ext)"
        return URL(string: urlString)
    }
}
