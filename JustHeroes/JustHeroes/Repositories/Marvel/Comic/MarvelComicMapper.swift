import Foundation

class MarvelComicMapper: CharactersRepositoryMapper {
    typealias DTO = MarvelDTO<MarvelComicDTO>
    
    func map(fromObject object: DTO) -> [BaseModel] {
        object.data.results.map { given -> BaseModel in
            let characterModel = BaseModel(
                name: given.title,
                description: given.description ?? given.variantDescription ?? ""
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
            return characterModel
        }
    }
    
}
