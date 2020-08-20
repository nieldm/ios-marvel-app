import Foundation
import UIKit

protocol CollectionViewDelegateOutput {
    func didSelect<Item: CollectionViewItem>(_ item: Item)
}

class CollectionViewDelegate<SectionItem: CollectionViewSection>: NSObject, UICollectionViewDelegateFlowLayout {
    
    private var dataSource: CollectionViewDataSource<SectionItem>
    var delegate: CollectionViewDelegateOutput?
    
    init(dataSource: CollectionViewDataSource<SectionItem>, delegate: CollectionViewDelegateOutput? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        dataSource.getSections()[indexPath.section].items[indexPath.row].getSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        dataSource.getSections()[section].spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.getSections()[indexPath.section].items[indexPath.row]
        delegate?.didSelect(item)
    }
}
