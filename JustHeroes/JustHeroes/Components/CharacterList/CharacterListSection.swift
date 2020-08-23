import Foundation
import UIKit

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

        //TODO: inject image repository
        if let characterImageURL = model.imageURL {
            item.imageDownloadTask = ImageRepository.shared.get(
                imageFrom: characterImageURL,
                withSize: nil,
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
