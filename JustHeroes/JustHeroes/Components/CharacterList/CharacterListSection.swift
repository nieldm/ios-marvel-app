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
    typealias Header = FullTitleCollectionReusableView
    typealias Footer = UICollectionReusableView
    typealias Item = CharacterListItem
    
    var items: [CharacterListItem]
    var spacing: CGFloat = 12.0
    
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
    
    func getHeaderSize(_ collectionView: UICollectionView) -> CGSize {
        .init(width: collectionView.frame.width, height: 100)
    }
    
    func getFooterSize(_ collectionView: UICollectionView) -> CGSize {
        .zero
    }
    
    func getHeader(header: FullTitleCollectionReusableView) -> FullTitleCollectionReusableView {
        header.titleLabel.text = "Characters"
        return header
    }
    
    func getFooter(footer: UICollectionReusableView) -> UICollectionReusableView {
        footer
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
        CGSize(width: 120, height: 250)
    }
    
    typealias Cell = CardCollectionViewCell
    typealias Model = CharacterModel
    
}
