import XCTest
@testable import JustHeroes

class CollectionViewItemMock: CollectionViewItem {
    var model: String = ""
    
    typealias Model = String
    typealias Cell = UICollectionViewCell
    
    var getCellCalled = false
    
    func prepare(cell: UICollectionViewCell) -> UICollectionViewCell {
        getCellCalled = true
        return UICollectionViewCell()
    }
    
    func getSize() -> CGSize {
        CGSize(width: 250, height: 265)
    }
}

class CollectionViewSectionMock: CollectionViewSection {
    typealias Header = UICollectionReusableView
    typealias Footer = UICollectionReusableView
    typealias Item = CollectionViewItemMock
    
    var headerCalled = false
    var footerCalled = false
    var preloadCalled = false
    var cancelPreloadCalled = false
    
    func getHeaderSize(_ collectionView: UICollectionView) -> CGSize {
        .zero
    }
    
    func getFooterSize(_ collectionView: UICollectionView) -> CGSize {
        .zero
    }
    
    func getHeader(header: UICollectionReusableView) -> UICollectionReusableView {
        headerCalled = true
        return header
    }
    
    func getFooter(footer: UICollectionReusableView) -> UICollectionReusableView {
        footerCalled = true
        return footer
    }
    
    var items: [CollectionViewItemMock]
    var spacing: CGFloat = 24.0
    
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
        frame: CGRect(x: 0, y: 0, width: 42, height: 42),
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
