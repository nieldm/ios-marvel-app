import Foundation
import UIKit

enum CollectionViewControllerStyle {
    case horizontal(paginated: Bool)
    case vertical(paginated: Bool)
    
    var scrollDirection: UICollectionView.ScrollDirection {
        switch self {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }
    
    var paginated: Bool {
        switch self {
        case .horizontal(let paginated):
            return paginated
        case .vertical(let paginated):
            return paginated
        }
    }
}

class CollectionViewController<SectionItem: CollectionViewSection>: UIViewController {
    
    let dataSource: CollectionViewDataSource<SectionItem>
    
    private let style: CollectionViewControllerStyle
    private var collectionView: UICollectionView
    private let delegate: UICollectionViewDelegate

    init(style: CollectionViewControllerStyle,
         delegate: UICollectionViewDelegate,
         dataSource: CollectionViewDataSource<SectionItem>) {
        self.delegate = delegate
        self.dataSource = dataSource
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = style.scrollDirection
        layout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        self.style = style
        super.init(nibName: nil, bundle: nil)
        
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = dataSource
        self.collectionView.prefetchDataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primary

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
        
        prepareView(view)
        prepareCollectionView(collectionView)
        
        collectionView.reloadData()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func prepareCollectionView(_ collectionView: UICollectionView) {}
    func prepareView(_ view: UIView) {}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
