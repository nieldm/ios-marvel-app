import Foundation

class BaseModel {
    let name: String
    let description: String
    
    var imageURL: URL?
    var highResImageURL: URL?
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
