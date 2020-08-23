import Foundation

protocol SortAndFilterBuilderProtocol {
    func createSortModule(forItems items: [SortFilterModel]) -> SortAndFilterListViewController
}

class SortAndFilterBuilder: SortAndFilterBuilderProtocol {
    
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
        let delegate = CollectionViewDelegate(dataSource: dataSource)
        
        return SortAndFilterListViewController(
            style: .vertical(paginated: false),
            delegate: delegate,
            dataSource: dataSource
        )
    }
    
}
