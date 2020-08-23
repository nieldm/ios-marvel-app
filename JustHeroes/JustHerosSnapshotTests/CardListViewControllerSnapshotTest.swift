import XCTest
import SnapshotTesting
@testable import JustHeroes

class CardListViewControllerSnapshotTest: XCTestCase {

    var sut: CardListViewController!
    
    override func setUpWithError() throws {
        sut = Assembler.shared.resolveCardListViewController_Test()
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
