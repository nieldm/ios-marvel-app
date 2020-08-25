import Foundation
import UIKit

class SimpleOptionCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            matchSelectedState()
        }
    }
    
    var titleLabel: UILabel
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        
        super.init(frame: .zero)
        
        addBorderAndCornerToCell(withFrame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        titleLabel.subheadlineStyle()
        titleLabel.textAlignment = .left
        titleLabel.text = "Sort Option"
        
        matchSelectedState()
    }
    
    private func matchSelectedState() {
        UIView.animate(withDuration: 0.3) {
            if self.isSelected {
                self.titleLabel.textColor = .secondary
                self.contentView.backgroundColor = .primary
            } else {
                self.titleLabel.textColor = .primary
                self.contentView.backgroundColor = .secondary
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
