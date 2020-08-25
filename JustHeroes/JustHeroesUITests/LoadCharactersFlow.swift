import XCTest

class LoadCharactersFlow: JustHeroesBaseUITests {

    func testLoadCharacters() throws {
        let cell = app.collectionViews.cells.firstMatch
        
        let exists = cell.waitForExistence(timeout: 3)
        XCTAssertTrue(exists)
    }
    
    func testFullDetailFlow() throws {
        
        let app = XCUIApplication()
        let element = app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element
        let exists = element.waitForExistence(timeout: 3)
        XCTAssertTrue(exists)
        element.tap()
        let hulkNavigationBar = app.navigationBars["Hulk"]
        XCTAssertTrue(
            hulkNavigationBar.waitForExistence(timeout: 3)
        )
        element.tap()
        let incredibleHulk1962102NavigationBar = app.navigationBars["Incredible Hulk (1962) #102"]
        XCTAssertTrue(
            incredibleHulk1962102NavigationBar.waitForExistence(timeout: 3)
        )
        let text = incredibleHulk1962102NavigationBar.staticTexts["Incredible Hulk (1962) #102"]
        XCTAssertTrue(
            text.waitForExistence(timeout: 3)
        )
        incredibleHulk1962102NavigationBar.buttons["Hulk"].tap()
        
        XCTAssertTrue(
            hulkNavigationBar.staticTexts["Hulk"].waitForExistence(timeout: 3)
        )
        hulkNavigationBar.buttons["Back"].tap()
        
    }

}
