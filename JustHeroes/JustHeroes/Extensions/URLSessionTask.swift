import Foundation
import UIKit

extension URLSessionTask {
    var cancelOrSuspended: Bool {
        switch self.state {
        case .canceling, .suspended:
            return true
        default:
            return false
        }
    }
}
