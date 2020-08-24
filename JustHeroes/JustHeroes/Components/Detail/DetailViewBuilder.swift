import Foundation

protocol DetailViewBuilderProtocol {
    func getDetailViewController(forModel model: CharacterModel) -> DetailViewController
}

class DetailViewBuilder: DetailViewBuilderProtocol {
    
    func getDetailViewController(forModel model: CharacterModel) -> DetailViewController {
        let viewModel = DetailViewModel(characterModel: model, imageRepository: ImageRepository.shared)
        let vc = DetailViewController(viewModel: viewModel)
        
        viewModel.view = vc
        vc.title = model.name
        
        return vc
    }
    
}
