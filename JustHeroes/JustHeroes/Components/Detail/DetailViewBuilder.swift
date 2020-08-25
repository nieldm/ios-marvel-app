import Foundation

protocol DetailViewBuilderProtocol {
    func getDetailViewController(forModel model: BaseModel) -> DetailViewController
}

class DetailViewBuilder: DetailViewBuilderProtocol {
    
    func getDetailViewController(forModel model: BaseModel) -> DetailViewController {
        let imageRepository = Assembler.shared.resolveImageRepository()
        
        let viewModel = DetailViewModel(characterModel: model, imageRepository: imageRepository)
        let vc: DetailViewController
        if let collectionURL = model.collectionURL {
            vc = DetailViewController(
                viewModel: viewModel,
                childViewController: try? Assembler.shared.resolveComicList(collectionURL: collectionURL)
            )
        } else {
            vc = DetailViewController(viewModel: viewModel)
        }
        
        viewModel.view = vc
        vc.title = model.name
        
        return vc
    }
    
}
