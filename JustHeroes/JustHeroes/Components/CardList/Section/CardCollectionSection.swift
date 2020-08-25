import Foundation
import UIKit

struct CardCollectionSection: CollectionViewSection {

    typealias Header = UICollectionReusableView
    typealias Footer = UICollectionReusableView
    typealias Item = CardCollectionItem
    
    var items: [CardCollectionItem]
    var spacing: CGFloat = 24.0

    //TODO: when downloading images or more info
    func preload(itemAt index: Int) {
        
    }
    
    func cancelPreload(itemAt index: Int) {
        
    }
    
    func getHeaderSize(_ collectionView: UICollectionView) -> CGSize {
        .zero
    }
    
    func getFooterSize(_ collectionView: UICollectionView) -> CGSize {
        .zero
    }
    
    func getHeader(header: UICollectionReusableView) -> UICollectionReusableView {
        header
    }
    
    func getFooter(footer: UICollectionReusableView) -> UICollectionReusableView {
        footer
    }
    
}
