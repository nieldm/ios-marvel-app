import Foundation
import UIKit

class CharacterListSection: CollectionViewSection {
    typealias Item = CharacterListItem
    
    var items: [CharacterListItem]
    var spacing: CGFloat = 24.0
    
    init(items: [CharacterListItem]) {
        self.items = items
    }
    
    func preload(itemAt index: Int) {
        
    }
    
    func cancelPreload(itemAt index: Int) {
        
    }
    
    func getHeader() -> UICollectionReusableView {
        UICollectionReusableView()
    }
    
    func getFooter() -> UICollectionReusableView {
        UICollectionReusableView()
    }
    
    
    
}

extension CharacterModel: CollectioViewModel {}

struct CharacterListItem: CollectionViewItem {
    var model: CharacterModel
    
    func prepare(cell: CardCollectionViewCell) -> UICollectionViewCell {
        cell.authorLabel.text = model.description
        cell.titleLabel.text = model.name
        return cell
    }
    
    func getSize() -> CGSize {
        CGSize(width: 100, height: 150)
    }
    
    typealias Cell = CardCollectionViewCell
    typealias Model = CharacterModel
    
}
