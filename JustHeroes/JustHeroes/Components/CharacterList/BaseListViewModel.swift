import Foundation

protocol BaseListViewModelView {
    func didReceive(characters: [BaseModel])
    func transition(toState state: ViewState)
    func presentDetail(forModel model: BaseModel)
}

protocol ViewModelViewCycleEvents {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
}

protocol BaseListViewModelViewProtocol {
    func didSearch(withTerm term: String)
}

enum ViewState {
    case loading
    case error(String)
    case idle
}

class BaseListViewModel: ViewModelViewCycleEvents {

    var view: BaseListViewModelView?
    var repository: BaseRepositoryProtocol
    private var lastSearchTerm: String?
    
    init(repository: BaseRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        lastSearchTerm = nil
        view?.transition(toState: .loading)
        repository.fetch(atPage: 0) { [weak self] (result) in
            self?.didReceive(result)
        }
    }
    
    func didReceive(_ result: BaseResult) {
        do {
            let characters = try result.get()
            self.view?.didReceive(characters: characters)
            self.view?.transition(toState: .idle)
        } catch {
            self.view?.transition(toState: .error(error.localizedDescription))
        }
    }
    
    func viewDidAppear() {}
    
    func viewDidDisappear() {}
    
}

extension BaseListViewModel: CollectionViewDelegateOutput {
    typealias Item = CharacterListItem
    
    func didSelect(_ item: CharacterListItem) {
        view?.presentDetail(forModel: item.model)
    }
}

extension BaseListViewModel: SortAndFilterViewModelOutput {
    func didSelectSort(byOption option: SortOptions) {
        self.view?.transition(toState: .loading)
        repository.fetch(atPage: 0, sortedBy: option, withTerm: self.lastSearchTerm ) { [weak self] result in
            self?.didReceive(result)
        }
    }
}

extension BaseListViewModel: BaseListViewModelViewProtocol {
    func didSearch(withTerm term: String) {
        self.view?.transition(toState: .loading)
        repository.fetch(atPage: 0, sortedBy: .none, withTerm: term) { [weak self] result in
            self?.lastSearchTerm = term
            self?.didReceive(result)
        }
    }
}
