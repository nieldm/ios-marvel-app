import Foundation

protocol CardListViewModelViewProtocol {
    func didReceive(characters: [CharacterModel])
    func transition(toState: ViewState)
}

protocol ViewModelViewCycleEvents {
    func viewDidLoad()
    func viewDidAppear()
}

enum ViewState {
    case loading
    case error(String)
    case idle
}

class CharacterListViewModel<Repository: CharactersRepository<MarvelDataSource, MarvelCharacterMapper>>: ViewModelViewCycleEvents {
    
    var view: CardListViewModelViewProtocol?
    var repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        view?.transition(toState: .loading)
        repository.fetchCharacters(atPage: 0) { [weak self] (result) in
            do {
                let characters = try result.get()
                self?.view?.didReceive(characters: characters)
                self?.view?.transition(toState: .idle)
            } catch {
                self?.view?.transition(toState: .error(error.localizedDescription))
            }
        }
    }
    
    func viewDidAppear() {}
}
