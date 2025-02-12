import Foundation
import UIKit

protocol CollectionViewDelegateOutput {
    associatedtype Item: CollectionViewItem
    
    func didSelect(_ item: Item)
}

class CollectionViewDelegate<SectionItem: CollectionViewSection, Output: CollectionViewDelegateOutput>: NSObject, UICollectionViewDelegateFlowLayout where SectionItem.Item == Output.Item {
    
    private var dataSource: CollectionViewDataSource<SectionItem>
    var delegate: Output?
    
    init(dataSource: CollectionViewDataSource<SectionItem>, delegate: Output? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        dataSource.getSections()[indexPath.section].items[indexPath.row].getSize(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        dataSource.getSections()[section].spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.getSections()[indexPath.section].items[indexPath.row]
        delegate?.didSelect(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        dataSource.getSections()[section].getHeaderSize(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        dataSource.getSections()[section].getFooterSize(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 12, left: 0, bottom: 12, right: 0)
    }
}
