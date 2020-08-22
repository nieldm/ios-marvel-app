import Foundation

class CharacterModel {
    let name: String
    let description: String
    
    var imageURL: URL?
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
