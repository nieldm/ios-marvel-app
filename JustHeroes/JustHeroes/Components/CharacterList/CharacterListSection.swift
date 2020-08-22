import Foundation
import UIKit

extension URLSessionTask {
    var cancelOrSuspended: Bool {
        switch self.state {
        case .canceling, .suspended:
            return true
        default:
            return false
        }
    }
}

class CharacterListSection: CollectionViewSection {
    typealias Item = CharacterListItem
    
    var items: [CharacterListItem]
    var spacing: CGFloat = 24.0
    
    init(items: [CharacterListItem]) {
        self.items = items
    }
    
    func preload(itemAt index: Int) {
        let item = items[index]
        
        guard item.image == nil,
            item.imageDownloadTask == nil,
            item.imageDownloadTask?.cancelOrSuspended ?? true else {
            return
        }
        let model = item.model
        print("👾", "Preload item \(index)")
        
        let size = Float(max(item.getSize().height, item.getSize().width))
        if let characterImageURL = model.imageURL {
            item.imageDownloadTask = ImageRepository.shared.get(
                imageFrom: characterImageURL,
                withSize: size,
                onSuccess: item.setImage(image:)
            )
        }
    }
    
    func cancelPreload(itemAt index: Int) {
        print("👾", "Cancel item \(index)")
        items[index].imageDownloadTask?.cancel()
    }
    
    func getHeader() -> UICollectionReusableView {
        UICollectionReusableView()
    }
    
    func getFooter() -> UICollectionReusableView {
        UICollectionReusableView()
    }
    
}

extension CharacterModel: CollectioViewModel {}

class CharacterListItem: CollectionViewItem {
    var model: CharacterModel
    weak var cell: CardCollectionViewCell?
    
    var image: UIImage?
    var imageDownloadTask: URLSessionTask?
    
    init(model: CharacterModel) {
        self.model = model
    }
    
    func prepare(cell: CardCollectionViewCell) -> UICollectionViewCell {
        self.cell = cell
        cell.authorLabel.text = model.description
        cell.titleLabel.text = model.name
        if let image = self.image {
            cell.imageView.image = image
        }
        return cell
    }
    
    func setImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.cell?.imageView.image = image
        }
        self.image = image
    }
    
    func getSize() -> CGSize {
        CGSize(width: 100, height: 150)
    }
    
    typealias Cell = CardCollectionViewCell
    typealias Model = CharacterModel
    
}
