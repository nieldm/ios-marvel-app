import UIKit

class CardListViewController: CollectionViewController {
    
    override func prepareView(_ view: UIView) {
        view.backgroundColor = .primary
    }
    
    override func prepareCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "CardCollectionViewCell"
        )
        collectionView.backgroundColor = .primary
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
}
