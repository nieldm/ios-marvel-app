import Foundation
import UIKit

class BaseListCollectionViewController: CollectionViewController<BaseListSection> {
    
    typealias ViewModel = ViewModelViewCycleEvents & SortAndFilterViewModelOutput & BaseListViewModelViewProtocol
    
    private let viewModel: ViewModel
    private let sortAndFilterViewController: SortAndFilterViewController
    private var throttleTimer: Timer?
    private let builder: DetailViewBuilderProtocol
    private let noContentView: NoContentView
    
    init(
        viewModel: ViewModel,
        delegate: UICollectionViewDelegate,
        dataSource: CollectionViewDataSource<BaseListSection>,
        builder: DetailViewBuilderProtocol) {
        self.viewModel = viewModel
        self.sortAndFilterViewController = Assembler.shared.resolveSortFilterModule(output: viewModel)
        self.builder = builder
        self.noContentView = NoContentView()
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
        
        noContentView.isHidden = true
        noContentView.backgroundColor = .primary
        view.addSubview(noContentView)
        noContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

extension BaseListCollectionViewController: BaseListViewModelView {
    func presentDetail(forModel model: BaseModel) {
        let vc = builder.getDetailViewController(forModel: model)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didReceive(characters: [BaseModel]) {
        //TODO: move map logic to the viewModel
        let items = characters.map { given -> BaseListItem in
            BaseListItem(model: given)
        }
        //TODO: add a builder to manage the sections titles
        self.dataSource.updateSections(sections: [BaseListSection(items: items)])
        self.reload()
    }
    
    func transition(toState state: ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.noContentView.startLoading()
            case .idle:
                self.noContentView.stopLoading()
            case .error(_):
                self.noContentView.stopLoading()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.noContentView.changeSize(size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
}

extension BaseListCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.viewDidLoad()
    }
}

extension BaseListCollectionViewController: UISearchResultsUpdating {
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
