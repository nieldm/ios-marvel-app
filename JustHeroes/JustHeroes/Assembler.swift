import Foundation
import UIKit

class Assembler {
    
    static let shared = Assembler()
    
    func getMarvelAPIKey() -> String? {
        ProcessInfo.processInfo.getEnviromentOption(.marvelAPIkey)
    }
    
    func getMarvelAPIPrivateKey() -> String? {
        ProcessInfo.processInfo.getEnviromentOption(.marvelAPIprivateKey)
    }
    
    func resolveStartViewController() -> UIViewController {
        let firstView: UIViewController
        
        switch ProcessInfo.processInfo.getStartView() {
        case .test:
            firstView = Assembler.shared.resolveCardListViewController_Test()
        case .sortFilter:
            firstView = Assembler.shared.resolveSortFilterModule()
        case .characterList:
            firstView = try! Assembler.shared.resolveCharacterList()
        case .comics:
            firstView = try! Assembler.shared.resolveComicList(
                collectionURL: "http://gateway.marvel.com/v1/public/characters/1009351/comics"
            )
        default:
            let navController = UINavigationController(
                rootViewController: try! resolveCharacterList()
            )
            firstView = navController
        }
        
        return firstView
    }
    
    func resolveImageRepository() -> ImageRepositoryProtocol {
        if ProcessInfo.processInfo.mockServer() {
            return MockImageRepository(delay: 0.0)
        }
        return ImageRepository()
    }
    
    func resolveBaseAPI() throws -> BaseAPIProtocol {
        if ProcessInfo.processInfo.mockServer() {
            return MockedBaseAPI(delay: 0.0)
        }
        return try BaseAPI(baseURL: MarvelDataSource.baseURL, session: .init(configuration: .default))
    }
    
    func resolveCharacterList() throws -> BaseListCollectionViewController {
        let api = try resolveBaseAPI()
        let mapper = MarvelCharacterMapper()
        let dataSource = MarverlCharacterDataSource(api: api)
        let repository = BaseRepository(pageSize: 100, dataSource: dataSource, mapper: mapper)
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
    
    /// Resolve the BaseListCollection with a comic collection list
    /// - Parameter collectionURL: Comic Collection list return by the character service
    /// - Throws: APIError
    /// - Returns: BaseListCollection with MarvelComic dependencies
    func resolveComicList(collectionURL: String) throws -> BaseListCollectionViewController {
        let api = try resolveBaseAPI()
        let mapper = MarvelComicMapper()
        let dataSource = MarverlComicsDataSource(collectionURL: collectionURL, api: api)
        let repository = BaseRepository(pageSize: 50, dataSource: dataSource, mapper: mapper)
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
