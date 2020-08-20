import UIKit

class CardListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource<CardCollectionSection>
    private var delegate: CollectionViewDelegate<CardCollectionSection>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primary

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        prepareCollectionView()
    }
    
    init(dataSource: CollectionViewDataSource<CardCollectionSection>,
         delegate: CollectionViewDelegate<CardCollectionSection>) {
        self.dataSource = dataSource
        self.delegate = delegate
        
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
        collectionView.delegate = delegate
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
