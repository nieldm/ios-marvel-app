import XCTest
@testable import JustHeroes

class CollectionViewItemMock: CollectionViewItem {
    typealias Cell = UICollectionViewCell
    
    var getCellCalled = false
    
    func prepare(cell: UICollectionViewCell) -> UICollectionViewCell {
        getCellCalled = true
        return UICollectionViewCell()
    }
}

class CollectionViewSectionMock: CollectionViewSection {
    typealias Item = CollectionViewItemMock
    
    var headerCalled = false
    var footerCalled = false
    var preloadCalled = false
    var cancelPreloadCalled = false
    
    func getHeader() -> UICollectionReusableView {
        headerCalled = true
        return UICollectionReusableView()
    }
    
    func getFooter() -> UICollectionReusableView {
        footerCalled = true
        return UICollectionReusableView()
    }
    
    var items: [CollectionViewItemMock]
    
    init(items: [CollectionViewItemMock]) {
        self.items = items
    }
    
    func preload(itemAt index: Int) {
        preloadCalled = true
    }
    
    func cancelPreload(itemAt index: Int) {
        cancelPreloadCalled = true
    }
}

class CollectionViewDataSourceTests: XCTestCase {
    
    var sut: CollectionViewDataSource<CollectionViewSectionMock>!
    var fakeCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    var itemMock: CollectionViewItemMock!
    var sectionMock: CollectionViewSectionMock!

    override func setUpWithError() throws {
        itemMock = CollectionViewItemMock()
        sectionMock = CollectionViewSectionMock(items: [itemMock])
        let sections = [sectionMock!]
        sut = .init(sections: sections)
    }
    
    func testNumberOfSections() throws {
        let result = sut.numberOfSections(in: fakeCollection)
        
        XCTAssertEqual(result, 1)
    }
    
    func testNumberOfItemsInSection() throws {
        let result = sut.collectionView(
            fakeCollection,
            numberOfItemsInSection: 0
        )
        
        XCTAssertEqual(result, 1)
    }
    
    func testUpdateSections() throws {
        sut.updateSections(
            sections: [
                CollectionViewSectionMock(
                    items: [itemMock, CollectionViewItemMock()
                ])
        ])
        
        let result = sut.collectionView(
            fakeCollection,
            numberOfItemsInSection: 0
        )
        
        XCTAssertEqual(result, 2)
    }

    func testCellForItemAt() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        fakeCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        _ = sut.collectionView(
            fakeCollection,
            cellForItemAt: indexPath
        )
        
        XCTAssertTrue(itemMock.getCellCalled)
    }
    
    func testViewForSupplementaryElementOfKindHeader() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        
        _ = sut.collectionView(
            fakeCollection,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        XCTAssertTrue(sectionMock.headerCalled)
        XCTAssertFalse(sectionMock.footerCalled)
    }
    
    func testViewForSupplementaryElementOfKindFooter() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        
        _ = sut.collectionView(
            fakeCollection,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter,
            at: indexPath
        )
        
        XCTAssertFalse(sectionMock.headerCalled)
        XCTAssertTrue(sectionMock.footerCalled)
    }
    
    func testViewForSupplementaryElementOfKind42() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        
        _ = sut.collectionView(
            fakeCollection,
            viewForSupplementaryElementOfKind: "42",
            at: indexPath
        )
        
        XCTAssertFalse(sectionMock.headerCalled)
        XCTAssertFalse(sectionMock.footerCalled)
    }
    
    func testPreload() throws {
        let indexPath = IndexPath(row: 0, section: 0)

        sut.collectionView(fakeCollection, prefetchItemsAt: [indexPath])
        
        XCTAssertTrue(sectionMock.preloadCalled)
        XCTAssertFalse(sectionMock.cancelPreloadCalled)
    }
    
    func testCancelPreload() throws {
        let indexPath = IndexPath(row: 0, section: 0)

        sut.collectionView(fakeCollection, cancelPrefetchingForItemsAt: [indexPath])
        
        XCTAssertFalse(sectionMock.preloadCalled)
        XCTAssertTrue(sectionMock.cancelPreloadCalled)
    }

}
