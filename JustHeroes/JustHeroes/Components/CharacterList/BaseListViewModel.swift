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

struct FetchProperties: Equatable {
    let searchTerm: String?
    let sort: SortOptions
}

class BaseListViewModel: ViewModelViewCycleEvents {

    var view: BaseListViewModelView?
    var repository: BaseRepositoryProtocol
    private var lastFetchProperties: FetchProperties?
    init(repository: BaseRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        let props = FetchProperties(searchTerm: nil, sort: .dateDesc)
        fetchIfNeeded(withProperties: props)
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
    
    private func fetchIfNeeded(withProperties props: FetchProperties) {
        guard props != lastFetchProperties else {
            return
        }
        lastFetchProperties = props
        view?.transition(toState: .loading)
        repository.fetch(atPage: 0, sortedBy: props.sort, withTerm: props.searchTerm ) { [weak self] result in
            self?.didReceive(result)
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
        let props = FetchProperties(
            searchTerm: lastFetchProperties?.searchTerm,
            sort: option
        )
        fetchIfNeeded(withProperties: props)
    }
}

extension BaseListViewModel: BaseListViewModelViewProtocol {
    func didSearch(withTerm term: String) {
        let props = FetchProperties(
            searchTerm: term,
            sort: .none
        )
        fetchIfNeeded(withProperties: props)
    }
}
