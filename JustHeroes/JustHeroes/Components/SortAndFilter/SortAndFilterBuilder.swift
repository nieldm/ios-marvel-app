import Foundation

protocol SortAndFilterBuilderProtocol: class {
    func createSortModule(forItems items: [SortFilterModel]) -> SortAndFilterListViewController
}

class SortAndFilterBuilder<Delegate: CollectionViewDelegateOutput>: SortAndFilterBuilderProtocol where Delegate.Item == SortFilterItem {
    let collectionViewDelegate: Delegate
    
    init(collectionViewDelegate: Delegate) {
        self.collectionViewDelegate = collectionViewDelegate
    }
    
    func createSortModule(forItems items: [SortFilterModel]) -> SortAndFilterListViewController {
        let sortOptions = items.map { given -> SortFilterItem in
            SortFilterItem(model: given)
        }
        
        let sortSection = SortFilterSection(
            title: "Sort Options",
            identifier: "sort",
            items: sortOptions
        )
        
        let dataSource = CollectionViewDataSource<SortFilterSection>(sections: [sortSection])
        let delegate = CollectionViewDelegate<SortFilterSection, Delegate>(
            dataSource: dataSource, delegate: collectionViewDelegate
        )
        
        return SortAndFilterListViewController(
            style: .vertical(paginated: false),
            delegate: delegate,
            dataSource: dataSource
        )
    }
    
}
