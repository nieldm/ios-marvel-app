import UIKit
import SnapKit

class CardCollectionViewCell: UICollectionViewCell {
     
    var imageView: UIImageView
    var titleLabel: UILabel
    var effectView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        titleLabel = UILabel()
        
        super.init(frame: .zero)
        
        createVisualEffectViewBasedOnTheInterfaceStyle()
        addBorderAndCornerToCell(withFrame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        prepareImageView()
        
        contentView.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.right.bottom.left.equalToSuperview()
        }
        
        effectView.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        titleLabel.subheadlineStyle()
        titleLabel.textAlignment = .center
        titleLabel.text = "Iron Man"
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func createVisualEffectViewBasedOnTheInterfaceStyle() {
        let blurEffect: UIBlurEffect
        if self.traitCollection.userInterfaceStyle == .dark {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        effectView = UIVisualEffectView(effect: blurEffect)
    }

    private func prepareImageView() {
        imageView.backgroundColor = .secondary
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
