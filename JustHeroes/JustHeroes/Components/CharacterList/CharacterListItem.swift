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
        CGSize(width: 120, height: 250)
    }
    
    typealias Cell = CardCollectionViewCell
    typealias Model = CharacterModel
    
}