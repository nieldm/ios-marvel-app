import Foundation

/// - Parameters:
///   - name: string to represent item to be presented
///   - description: description of the item
///   - imageURL: this image if present will be used on the small representation of the item
///   - highResImageURL: this image if present will be used on the detail
///   - collectionURL: if present the detail will request and show child elements like characters > comics
class BaseModel {
    let name: String
    let description: String
    
    var imageURL: URL?
    var highResImageURL: URL?
    
    var collectionURL: String?
    
    /// this model will be used to take a generic aproach of the data
    /// - Parameters:
    ///   - name: string to represent item to be presented
    ///   - description: description of the item
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
