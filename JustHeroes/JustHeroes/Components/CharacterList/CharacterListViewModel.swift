import Foundation

protocol CharacterListViewModelView {
    func didReceive(characters: [BaseModel])
    func transition(toState state: ViewState)
    func presentDetail(forModel model: BaseModel)
}

protocol ViewModelViewCycleEvents {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
}

protocol ModelListViewModelViewProtocol {
    func didSearch(withTerm term: String)
}

enum ViewState {
    case loading
    case error(String)
    case idle
}

class CharacterListViewModel: ViewModelViewCycleEvents {

    var view: CharacterListViewModelView?
    var repository: CharactersRepositoryProtocol
    private var lastSearchTerm: String?
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        lastSearchTerm = nil
        view?.transition(toState: .loading)
//        repository.fetch(atPage: 0) { [weak self] (result) in
//            self?.didReceive(result)
//        }
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

extension CharacterListViewModel: CollectionViewDelegateOutput {
    typealias Item = CharacterListItem
    
    func didSelect(_ item: CharacterListItem) {
        view?.presentDetail(forModel: item.model)
    }
}

extension CharacterListViewModel: SortAndFilterViewModelOutput {
    func didSelectSort(byOption option: SortOptions) {
        repository.fetch(atPage: 0, sortedBy: option, withTerm: self.lastSearchTerm ) { [weak self] result in
            self?.didReceive(result)
        }
    }
}

extension CharacterListViewModel: ModelListViewModelViewProtocol {
    func didSearch(withTerm term: String) {
        repository.fetch(atPage: 0, sortedBy: .none, withTerm: term) { [weak self] result in
            self?.lastSearchTerm = term
            self?.didReceive(result)
        }
    }
}
