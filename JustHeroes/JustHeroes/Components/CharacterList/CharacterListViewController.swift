import Foundation
import UIKit

class CharacterListViewController: CollectionViewController<CharacterListSection> {
    
    typealias ViewModel = ViewModelViewCycleEvents & SortAndFilterViewModelOutput
    
    let viewModel: ViewModel
    let sortAndFilterViewController: SortAndFilterViewController
    
    init(
        viewModel: ViewModel,
        delegate: UICollectionViewDelegate,
        dataSource: CollectionViewDataSource<CharacterListSection>) {
        self.viewModel = viewModel
        self.sortAndFilterViewController = Assembler.shared.resolveSortFilterModule(output: viewModel)
        super.init(style: .vertical(paginated: false), delegate: delegate, dataSource: dataSource)
    }
    
    override func prepareView(_ view: UIView) {
        view.backgroundColor = .primary
        
        view.addSubview(sortAndFilterViewController.view)
        addChild(sortAndFilterViewController)
        sortAndFilterViewController.didMove(toParent: self)
        sortAndFilterViewController.view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(12)
            make.height.equalTo(60)
        }
        sortAndFilterViewController.view.backgroundColor = .clear
    }
    
    override func prepareCollectionView(_ collectionView: UICollectionView) {
        //TODO: build a helper to register
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "CardCollectionViewCell"
        )
        collectionView.register(
            FullTitleCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "FullTitleCollectionReusableView"
        )
        collectionView.backgroundColor = .primary
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 24, right: 12)
    }
    
    override func viewDidLoad() {
        viewModel.viewDidLoad()
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CharacterListViewController: CardListViewModelViewProtocol {
    func didReceive(characters: [CharacterModel]) {
        //TODO: move map logic to the viewModel
        let items = characters.map { given -> CharacterListItem in
            CharacterListItem(model: given)
        }
        self.dataSource.updateSections(sections: [CharacterListSection(items: items)])
        self.reload()
    }
    
    func transition(toState: ViewState) {
        
    }
    
}
