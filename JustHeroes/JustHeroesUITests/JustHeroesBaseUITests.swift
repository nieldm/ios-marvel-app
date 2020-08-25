import XCTest

class JustHeroesBaseUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment = [
            "MARVEL_PRIVATE_KEY": "0",
            "MARVEL_API_KEY": "0",
            "MOCK_SERVER": "YES"
        ]
        app.launch()
        try super.setUpWithError()
    }
    
}
