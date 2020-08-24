import Foundation

struct MarvelDTO<Type: Codable>: Codable {
    let data: MarvelDataDTO<Type>
}

struct MarvelDataDTO<Type: Codable>: Codable {
    let total: Int
    let count: Int
    let results: [Type]
}

struct MarvelCharacterDTO: Codable {
    let id: UInt
    let name: String
    let description: String
    let thumbnail: MarvelImageDTO
    let resourceURI: String
    let urls: [MarvelUrlDTO]
    let comics: MarvelSummaryDTO?
}

struct MarvelComicDTO: Codable {
    let id: String
    let title: String
    let description: String
    let thumbnail: MarvelImageDTO
}

struct MarvelImageDTO: Codable {
    let path: String
    let `extension`: String
}

struct MarvelUrlDTO: Codable {
    let type: String
    let url: String
}

struct MarvelSummaryDTO: Codable {
    let collectionURI: String
    let available: Int
}
