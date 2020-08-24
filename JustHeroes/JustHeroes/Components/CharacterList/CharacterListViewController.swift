import Foundation
import UIKit

class CharacterListViewController: CollectionViewController<CharacterListSection> {
    
    typealias ViewModel = ViewModelViewCycleEvents & SortAndFilterViewModelOutput & CharacterListViewModelViewProtocol
    
    private let viewModel: ViewModel
    private let sortAndFilterViewController: SortAndFilterViewController
    private var throttleTimer: Timer?
    private let builder: DetailViewBuilderProtocol
    
    init(
        viewModel: ViewModel,
        delegate: UICollectionViewDelegate,
        dataSource: CollectionViewDataSource<CharacterListSection>,
        builder: DetailViewBuilderProtocol) {
        self.viewModel = viewModel
        self.sortAndFilterViewController = Assembler.shared.resolveSortFilterModule(output: viewModel)
        self.builder = builder
        super.init(style: .vertical(paginated: false), delegate: delegate, dataSource: dataSource)
    }
    
    override func prepareView(_ view: UIView) {
        addSearchController()
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.viewDidDisappear()
        super.viewDidDisappear(animated)
    }
    
    private func addSearchController() {
        let search = UISearchController()
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CharacterListViewController: CharacterListViewModelView {
    func presentDetail(forModel model: CharacterModel) {
        let vc = builder.getDetailViewController(forModel: model)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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

extension CharacterListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.viewDidLoad()
    }
}

extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.throttleTimer?.invalidate()
        guard let term = searchController.searchBar.text else {
            return
        }
        guard !term.isEmpty else {
            return self.viewModel.viewDidLoad()
        }
        guard term.count > 3 else {
            return
        }
        throttleTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.viewModel.didSearch(withTerm: term)
        }
    }
}
