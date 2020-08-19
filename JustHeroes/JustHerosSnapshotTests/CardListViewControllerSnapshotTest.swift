import XCTest
import SnapshotTesting
@testable import JustHeroes

class CardListViewControllerSnapshotTest: XCTestCase {

    func testLigthMode() {
        let vc = Assembler.shared.resolveCardListViewController_Test()
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(
            matching: vc.view,
            as: .image
        )
    }
    
    func testDarkMode() {
        let vc = Assembler.shared.resolveCardListViewController_Test()
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(
            matching: vc.view,
            as: .image
        )
    }

}
