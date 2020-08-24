import Foundation

enum MarvelImageResolution: String {
    case portraitFantastic = "/portrait_fantastic"
    case fullSize = ""
}

class MarvelImageURLBuilder {
    static func getImageURL(withPath path: String, ext: String, resolution: MarvelImageResolution) -> URL? {
        let urlString = "\(path)\(resolution.rawValue).\(ext)"
        return URL(string: urlString)
    }
}
