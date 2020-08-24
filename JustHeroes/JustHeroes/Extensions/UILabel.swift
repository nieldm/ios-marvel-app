import Foundation
import UIKit

extension UILabel {
    
    func largeTitleStyle() {
        self.numberOfLines = 2
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        self.textColor = .secondary
        self.textAlignment = .left
    }
    
    func subheadlineStyle() {
        self.numberOfLines = 2
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.textColor = .secondary
        self.textAlignment = .left
    }
    
    func subheadlineThinStyle() {
        let baseFont = UIFont.preferredFont(forTextStyle: .subheadline)
        self.numberOfLines = 2
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(
            ofSize: baseFont.pointSize,
            weight: .thin
        )
        self.textColor = .secondary
        self.textAlignment = .left
    }
    
    func descriptionStyle() {
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = false
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.textColor = .secondary
        self.textAlignment = .left
    }
}
