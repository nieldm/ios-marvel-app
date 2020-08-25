import XCTest

class JustHeroesBaseUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment = [
            "MARVEL_PRIVATE_KEY": "08b5e01b1697c99d25d7f59b0b2f2d252f109edd",
            "MARVEL_API_KEY": "885d2218c82dce59c8159ef7d42823fe"
        ]
        app.launch()
        try super.setUpWithError()
    }
    
}
