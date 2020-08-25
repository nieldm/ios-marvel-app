import Foundation

enum EnviromentOption: String {
    case startView = "START_VIEW"
    case marvelAPIkey = "MARVEL_API_KEY"
    case marvelAPIprivateKey = "MARVEL_PRIVATE_KEY"
    case mockServer = "MOCK_SERVER"
}

extension ProcessInfo {
    
    func getEnviromentOption(_ option: EnviromentOption) -> String? {
        return environment[option.rawValue]
    }
    
    func getStartView() -> StartView {
        let startView = getEnviromentOption(.startView) ?? ""
        return StartView(rawValue: startView) ?? StartView.none
    }
    
    func mockServer() -> Bool {
        getEnviromentOption(.mockServer) == "YES"
    }
}

enum StartView: String {
    case test
    case characterList
    case sortFilter
    case comics
    case none = ""
}
