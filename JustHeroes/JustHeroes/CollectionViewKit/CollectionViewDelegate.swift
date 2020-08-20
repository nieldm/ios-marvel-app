import Foundation
import UIKit

protocol CollectionViewDelegateOutput {
    func didSelect<Item: CollectionViewItem>(_ item: Item)
}

class CollectionViewDelegate<SectionItem: CollectionViewSection>: NSObject, UICollectionViewDelegateFlowLayout {
    
    private var sections: [SectionItem]
    var delegate: CollectionViewDelegateOutput?
    
    init(sections: [SectionItem], delegate: CollectionViewDelegateOutput? = nil) {
        self.sections = sections
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sections[indexPath.section].items[indexPath.row].getSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sections[section].spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        delegate?.didSelect(item)
    }
}
