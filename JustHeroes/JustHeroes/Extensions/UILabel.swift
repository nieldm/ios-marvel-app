import Foundation
import UIKit

extension UILabel {
    func titleStyle() {
        self.numberOfLines = 2
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.textColor = .secondary
        self.textAlignment = .left
    }
    
    func descriptionStyle() {
        let baseFont = UIFont.preferredFont(forTextStyle: .subheadline)
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(
            ofSize: baseFont.pointSize,
            weight: .thin
        )
        self.textColor = .secondary
        self.textAlignment = .left
    }
}
