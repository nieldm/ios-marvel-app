import UIKit

class CardListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource<CardCollectionSection>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primary

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        prepareCollectionView()
    }
    
    init(dataSource: CollectionViewDataSource<CardCollectionSection>) {
        self.dataSource = dataSource
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        super.init(nibName: nil, bundle: nil)
    }

    private func prepareCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.delegate = self
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "CardCollectionViewCell"
        )
        collectionView.backgroundColor = .primary
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//TODO: Move this to CollectionViewKit
extension CardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 265)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
