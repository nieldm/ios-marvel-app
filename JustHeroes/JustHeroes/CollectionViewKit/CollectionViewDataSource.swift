import Foundation
import UIKit

class CollectionViewDataSource<SectionItem: CollectionViewSection>
: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    private var sections: [SectionItem]
    
    init(sections: [SectionItem]) {
        self.sections = sections
    }
    
    func updateSections(sections: [SectionItem]) {
        self.sections = sections
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: SectionItem.Item.Cell.self)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SectionItem.Item.Cell else {
            fatalError("Missing Cell")
        }
        
        return sections[indexPath.section].items[indexPath.row].prepare(cell: cell)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return section.getHeader()
        case UICollectionView.elementKindSectionFooter:
            return section.getFooter()
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { [weak self] indexPath in
            self?.sections[indexPath.section].preload(itemAt: indexPath.row)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { [weak self] indexPath in
            self?.sections[indexPath.section].cancelPreload(itemAt: indexPath.row)
        }
    }
    
}
