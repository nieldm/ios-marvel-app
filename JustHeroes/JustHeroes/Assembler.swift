import Foundation

struct CardCollectionViewDelegateOutputMock: CollectionViewDelegateOutput {
    typealias Item = CardCollectionItem
    
    func didSelect(_ item: CardCollectionItem) {
        
    }
}

class Assembler {
    
    static let shared = Assembler()
    
    func resolveCharacterList() throws -> CharacterListViewController {
        let api = try BaseAPI(baseURL: MarvelDataSource.baseURL, session: .init(configuration: .default))
        let mapper = MarvelCharacterMapper()
        let dataSource = MarvelDataSource(api: api)
        let repository = CharactersRepository(pageSize: 100, dataSource: dataSource, mapper: mapper)
        let viewModel = CharacterListViewModel(repository: repository)
        let collectionDataSource = CollectionViewDataSource<CharacterListSection>(sections: [])
        let collectionDelegate = CollectionViewDelegate(dataSource: collectionDataSource, delegate: viewModel)
        let vc = CharacterListViewController(
            viewModel: viewModel,
            delegate: collectionDelegate,
            dataSource: collectionDataSource
        )
        viewModel.view = vc
        return vc
    }
    
    func resolveCardListViewController_Test() -> CardListViewController {
        let section1 = CardCollectionSection(
            items: [
                CardCollectionItem(model: ""),
                CardCollectionItem(model: ""),
                CardCollectionItem(model: ""),
                CardCollectionItem(model: ""),
                CardCollectionItem(model: "")
            ]
        )
        
        let section2 = CardCollectionSection(
            items: [
                CardCollectionItem(model: "")
            ]
        )
        
        let sections = [section1, section2]
        let dataSource = resolveCardListDataSource(sections: sections)
        let delegate = resolveCardListDelegate(dataSource: dataSource, output: CardCollectionViewDelegateOutputMock())
        
        return CardListViewController(
            style: .vertical(paginated: false),
            delegate: delegate,
            dataSource: dataSource
        )
    }
    
    func resolveCardListDataSource<Section: CollectionViewSection>(sections: [Section]) -> CollectionViewDataSource<Section> {
        CollectionViewDataSource(sections: sections)
    }
    
    func resolveCardListDelegate<Section: CollectionViewSection, Output: CollectionViewDelegateOutput>(dataSource: CollectionViewDataSource<Section>, output: Output) -> CollectionViewDelegate<Section, Output> {
        CollectionViewDelegate(dataSource: dataSource, delegate: output)
    }
    
    func resolveSortFilterModule() -> SortAndFilterViewController {
        let viewModel = SortAndFilterViewModel()
        let builder = SortAndFilterBuilder(collectionViewDelegate: viewModel)
        let vc = SortAndFilterViewController(viewModel: viewModel, builder: builder)
        
        viewModel.view = vc
        
        return vc
    }
    
}
