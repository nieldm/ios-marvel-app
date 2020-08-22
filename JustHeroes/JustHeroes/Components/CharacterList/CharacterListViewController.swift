import Foundation
import UIKit

class CharacterListViewController: CollectionViewController<CharacterListSection> {
    
    let viewModel: ViewModelViewCycleEvents
    
    init(
        viewModel: ViewModelViewCycleEvents,
        delegate: UICollectionViewDelegate,
        dataSource: CollectionViewDataSource<CharacterListSection>) {
        self.viewModel = viewModel
        super.init(style: .vertical(paginated: false), delegate: delegate, dataSource: dataSource)
    }
    
    override func prepareView(_ view: UIView) {
        view.backgroundColor = .primary
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
