import Foundation
import UIKit

struct CardCollectionSection: CollectionViewSection {
    typealias Item = CardCollectionItem
    
    var items: [CardCollectionItem]
    var spacing: CGFloat = 24.0
    
    func getFooter() -> UICollectionReusableView {
        UICollectionReusableView()
    }
    func getHeader() -> UICollectionReusableView {
        UICollectionReusableView()
    }
    
    //TODO: when downloading images or more info
    func preload(itemAt index: Int) {
        
    }
    
    func cancelPreload(itemAt index: Int) {
        
    }
    
}
