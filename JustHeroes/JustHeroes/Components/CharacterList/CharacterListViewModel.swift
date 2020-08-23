import Foundation

protocol CardListViewModelViewProtocol {
    func didReceive(characters: [CharacterModel])
    func transition(toState: ViewState)
}

protocol ViewModelViewCycleEvents {
    func viewDidLoad()
    func viewDidAppear()
}

protocol CharacterListViewModelViewProtocol {
    func didSearch(withTerm term: String)
}

enum ViewState {
    case loading
    case error(String)
    case idle
}

class CharacterListViewModel<Repository: CharactersRepository<MarvelDataSource, MarvelCharacterMapper>>: ViewModelViewCycleEvents {
    
    var view: CardListViewModelViewProtocol?
    var repository: Repository
    private var lastSearchTerm: String?
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        lastSearchTerm = nil
        view?.transition(toState: .loading)
        repository.fetchCharacters(atPage: 0) { [weak self] (result) in
            self?.didReceive(result)
        }
    }
    
    func didReceive(_ result: CharacterResult) {
        do {
            let characters = try result.get()
            self.view?.didReceive(characters: characters)
            self.view?.transition(toState: .idle)
        } catch {
            self.view?.transition(toState: .error(error.localizedDescription))
        }
    }
    
    func viewDidAppear() {}
}

extension CharacterListViewModel: CollectionViewDelegateOutput {
    typealias Item = CharacterListItem
    
    func didSelect(_ item: CharacterListItem) {
        print("👾", "did select \(item.model.name)")
    }
}

extension CharacterListViewModel: SortAndFilterViewModelOutput {
    func didSelectSort(byOption option: SortOptions) {
        repository.fetchCharacters(atPage: 0, sortedBy: option, withTerm: self.lastSearchTerm ) { [weak self] result in
            self?.didReceive(result)
        }
    }
}

extension CharacterListViewModel: CharacterListViewModelViewProtocol {
    func didSearch(withTerm term: String) {
        repository.fetchCharacters(atPage: 0, sortedBy: .none, withTerm: term) { [weak self] result in
            self?.lastSearchTerm = term
            self?.didReceive(result)
        }
    }
}
