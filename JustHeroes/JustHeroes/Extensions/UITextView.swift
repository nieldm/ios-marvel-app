import Foundation
import UIKit

extension UITextView {
    func descriptionStyle() {
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.textColor = .secondary
        self.textAlignment = .left
    }
}
