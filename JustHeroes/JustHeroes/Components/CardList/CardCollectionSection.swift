import Foundation
import UIKit

struct CardCollectionSection: CollectionViewSection {
    var items: [CardCollectionItem]

    typealias Item = CardCollectionItem
    
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
