import Foundation
import UIKit

extension BaseModel: CollectioViewModel {}

class BaseListItem: CollectionViewItem {
    var model: BaseModel
    weak var cell: CardCollectionViewCell?
    
    var image: UIImage?
    var imageDownloadTask: URLSessionTask?
    
    init(model: BaseModel) {
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
    typealias Model = BaseModel
    
}
