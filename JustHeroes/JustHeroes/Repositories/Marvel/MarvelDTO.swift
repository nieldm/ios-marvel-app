import Foundation

struct MarvelDTO: Codable {
    let data: MarvelDataDTO
}

struct MarvelDataDTO: Codable {
    let total: Int
    let count: Int
    let results: [MarvelCharacterDTO]
}

struct MarvelCharacterDTO: Codable {
    let id: UInt
    let name: String
    let description: String
    let thumbnail: MarvelImageDTO
    let resourceURI: String
    let urls: [MarvelUrlDTO]
//    let comics: [MarvelComicSummaryDTO]
}

struct MarvelImageDTO: Codable {
    let path: String
    let `extension`: String
}

struct MarvelUrlDTO: Codable {
    let type: String
    let url: String
}

struct MarvelComicSummaryDTO: Codable {
    let resourceURI: String
    let name: String
}
