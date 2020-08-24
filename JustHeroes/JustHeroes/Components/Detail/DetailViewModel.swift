import Foundation
import UIKit

protocol DetailViewModelView: class {
    func set(model: CharacterModel)
    //TODO: remove uikit dependency to the view model
    func set(image: UIImage)
}

protocol DetailViewModelProtocol {
    
}

class DetailViewModel: ViewModelViewCycleEvents {
    
    weak var view: DetailViewModelView?
    private let characterModel: CharacterModel
    private let imageRepository: ImageRepositoryProtocol
    private var imageDownloadTask: URLSessionTask?
    
    init(characterModel: CharacterModel, imageRepository: ImageRepositoryProtocol) {
        self.characterModel = characterModel
        self.imageRepository = imageRepository
    }
    
    func viewDidLoad() {
        if let highResImageURL = characterModel.highResImageURL {
            let task = imageRepository.get(imageFrom: highResImageURL, withSize: nil) { [weak self] (image) in
                self?.view?.set(image: image)
            }
            imageDownloadTask = task
        }
        view?.set(model: characterModel)
    }
    
    func viewDidAppear() {}
    
    func viewDidDisappear() {
        imageDownloadTask?.cancel()
    }
}
