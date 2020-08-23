import Foundation
import UIKit

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
    
    func getSize(_ collectionView: UICollectionView?) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSize(width: 120, height: 250)
        }
        
        return collectionView.frame.divide(
            by: 3,
            withSpacing: 12,
            withAspect: 250.0 / 120.0,
            maxSize: 120
        )
    }
    
    typealias Cell = CardCollectionViewCell
    typealias Model = CharacterModel
    
}

private extension CGRect {
    func divide(
        by number: CGFloat,
        withSpacing spacing: CGFloat = 0,
        withAspect aspect: CGFloat = 0,
        maxSize: CGFloat = .infinity) -> CGSize {
        
        let proportion: CGFloat = 1.0 / number
        let spacing = spacing * (number - 1.0)
        let newWidth = min((width * proportion) - spacing, maxSize)
        
        return CGSize(width: newWidth, height: newWidth * aspect)
    }
}
