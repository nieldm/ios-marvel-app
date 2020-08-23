import UIKit

class SortAndFilterListViewController: CollectionViewController<SortFilterSection> {

    override func prepareView(_ view: UIView) {
        view.backgroundColor = .primary
    }
    
    override func prepareCollectionView(_ collectionView: UICollectionView) {
        //TODO: build a helper to register
        collectionView.register(
            SimpleOptionCollectionViewCell.self,
            forCellWithReuseIdentifier: "SimpleOptionCollectionViewCell"
        )
        collectionView.register(
            FullTitleCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "FullTitleCollectionReusableView"
        )
        collectionView.backgroundColor = .primary
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 24, right: 12)
    }
}
