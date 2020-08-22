import UIKit

class CardListViewController: CollectionViewController<CardCollectionSection> {
    
    override func prepareView(_ view: UIView) {
        view.backgroundColor = .primary
    }
    
    override func prepareCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "CardCollectionViewCell"
        )
        collectionView.backgroundColor = .primary
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
}
