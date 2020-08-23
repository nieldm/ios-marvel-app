import Foundation
import UIKit

class SortFilterSection: CollectionViewSection {
    typealias Item = SortFilterItem
    
    typealias Header = FullTitleCollectionReusableView
    typealias Footer = FullTitleCollectionReusableView
    
    let title: String
    let identifier: String
    let items: [SortFilterItem]
    var spacing: CGFloat = 0
    
    init(title: String, identifier: String, items: [SortFilterItem]) {
        self.title = title
        self.identifier = identifier
        self.items = items
    }
    
    func preload(itemAt index: Int) {}
    
    func cancelPreload(itemAt index: Int) {}
    
    func getHeaderSize(_ collectionView: UICollectionView) -> CGSize {
        .init(width: collectionView.frame.width, height: 44)
    }
    
    func getFooterSize(_ collectionView: UICollectionView) -> CGSize {
        .zero
    }
    
    func getHeader(header: FullTitleCollectionReusableView) -> FullTitleCollectionReusableView {
        header.titleLabel.text = title
        return header
    }
    
    func getFooter(footer: FullTitleCollectionReusableView) -> FullTitleCollectionReusableView {
        footer
    }
}
