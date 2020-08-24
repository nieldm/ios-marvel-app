import Foundation

class MarvelCharacterMapper: CharactersRepositoryMapper {
    typealias DTO = MarvelDTO<MarvelCharacterDTO>
    
    func map(fromObject object: DTO) -> [BaseModel] {
        object.data.results.map { given -> BaseModel in
            let characterModel = BaseModel(
                name: given.name,
                description: given.description
            )
            characterModel.imageURL = MarvelImageURLBuilder.getImageURL(
                withPath: given.thumbnail.path,
                ext: given.thumbnail.`extension`,
                resolution: .portraitFantastic
            )
            characterModel.highResImageURL = MarvelImageURLBuilder.getImageURL(
                withPath: given.thumbnail.path,
                ext: given.thumbnail.`extension`,
                resolution: .fullSize
            )
            characterModel.collectionURL = given.comics?.collectionURI
            return characterModel
        }
    }
}
