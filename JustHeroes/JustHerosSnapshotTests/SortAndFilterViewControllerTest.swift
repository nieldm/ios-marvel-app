import XCTest
import SnapshotTesting
@testable import JustHeroes

class SortAndFilterViewControllerTest: XCTestCase {

    var sut: SortAndFilterListViewController!
    
    override func setUpWithError() throws {
        
        let items = [
            SortFilterModel(name: "Name Asc", value: "name_asc"),
            SortFilterModel(name: "Name Desc", value: "name_desc"),
            SortFilterModel(name: "Date Asc", value: "date_asc"),
            SortFilterModel(name: "Date Desc", value: "date_desc")
        ]
        
        let sortOptions = items.map { given -> SortFilterItem in
            SortFilterItem(model: given)
        }
        
        let sortSection = SortFilterSection(
            title: "Sort Options",
            identifier: "sort",
            items: sortOptions
        )
        
        let dataSource = CollectionViewDataSource<SortFilterSection>(sections: [sortSection])
        let delegate = CollectionViewDelegate<SortFilterSection, SortAndFilterViewModel>(
            dataSource: dataSource,
            delegate: SortAndFilterViewModel()
        )
        sut = SortAndFilterListViewController(style: .vertical(paginated: false), delegate: delegate, dataSource: dataSource)
    }
    
    func testLigthMode() {
        sut.overrideUserInterfaceStyle = .light
        assertSnapshot(
            matching: sut.view,
            as: .image
        )
    }
    
    func testDarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        assertSnapshot(
            matching: sut.view,
            as: .image
        )
    }

}
