import Foundation

class Assembler {
    
    static let shared = Assembler()
    
    func resolveImageRepository() -> ImageRepositoryProtocol {
        let mockServer = ProcessInfo.processInfo.environment["MOCK_SERVER"] ?? "NO"
        if mockServer == "YES" {
            return MockImageRepository(delay: 0.0)
        }
        return ImageRepository()
    }
    
    func resolveBaseAPI() throws -> BaseAPIProtocol {
        let mockServer = ProcessInfo.processInfo.environment["MOCK_SERVER"] ?? "NO"
        if mockServer == "YES" {
            return MockedBaseAPI(delay: 0.0)
        }
        return try BaseAPI(baseURL: MarvelDataSource.baseURL, session: .init(configuration: .default))
    }
    
    func resolveCharacterList() throws -> BaseListCollectionViewController {
        let api = try resolveBaseAPI()
        let mapper = MarvelCharacterMapper()
        let dataSource = MarverlCharacterDataSource(api: api)
        let repository = BaseRepository(pageSize: 10, dataSource: dataSource, mapper: mapper)
        let viewModel = BaseListViewModel(repository: repository)
        let collectionDataSource = CollectionViewDataSource<BaseListSection>(sections: [])
        let collectionDelegate = CollectionViewDelegate(dataSource: collectionDataSource, delegate: viewModel)
        let builder = DetailViewBuilder()
        let vc = BaseListCollectionViewController(
            viewModel: viewModel,
            delegate: collectionDelegate,
            dataSource: collectionDataSource,
            builder: builder
        )
        viewModel.view = vc
        return vc
    }
    
    func resolveComicList(collectionURL: String) throws -> BaseListCollectionViewController {
        let api = try resolveBaseAPI()
        let mapper = MarvelComicMapper()
        let dataSource = MarverlComicsDataSource(collectionURL: collectionURL, api: api)
        let repository = BaseRepository(pageSize: 5, dataSource: dataSource, mapper: mapper)
        let viewModel = BaseListViewModel(repository: repository)
        let collectionDataSource = CollectionViewDataSource<BaseListSection>(sections: [])
        let collectionDelegate = CollectionViewDelegate(dataSource: collectionDataSource, delegate: viewModel)
        let builder = DetailViewBuilder()
        let vc = BaseListCollectionViewController(
            viewModel: viewModel,
            delegate: collectionDelegate,
            dataSource: collectionDataSource,
            builder: builder
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
    
    func resolveSortFilterModule(output: SortAndFilterViewModelOutput? = nil) -> SortAndFilterViewController {
        let viewModel = SortAndFilterViewModel()
        let builder = SortAndFilterBuilder(collectionViewDelegate: viewModel)
        let vc = SortAndFilterViewController(viewModel: viewModel, builder: builder)
        
        viewModel.output = output
        viewModel.view = vc
        
        return vc
    }
    
}
