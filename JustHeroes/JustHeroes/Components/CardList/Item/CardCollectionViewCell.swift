import UIKit
import SnapKit

class CardCollectionViewCell: UICollectionViewCell {
     
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var viewLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        imageView = UIImageView()
        titleLabel = UILabel()
        authorLabel = UILabel()
        viewLabel = UILabel()
        
        prepareCell(withFrame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        prepareImageView()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.right.equalToSuperview().inset(13)
            make.left.equalToSuperview().offset(13)
        }
        titleLabel.titleStyle()
        titleLabel.text = "Iron Man"
        
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        authorLabel.descriptionStyle()
        authorLabel.text = "Tony Stark"

        contentView.addSubview(viewLabel)
        viewLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.equalTo(authorLabel)
        }
        prepareViewLabel()
        
        let buttonIcon = UIImageView()
        contentView.addSubview(buttonIcon)
        buttonIcon.snp.makeConstraints { make in
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-12)
        }
        buttonIcon.image = UIImage(named: "buttonIndicator")
        buttonIcon.tintColor = .secondary
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func prepareCell(withFrame frame: CGRect) {
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 6
        contentView.layer.borderColor = UIColor.cellBackground.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.secondary.cgColor
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = CGPath(
            roundedRect: CGRect(origin: .init(x: -1, y: -1), size: frame.size),
            cornerWidth: 6,
            cornerHeight: 0,
            transform: nil
        )
        layer.shadowOffset = .zero
    }
    
    private func prepareImageView() {
        imageView.backgroundColor = .secondary
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    private func prepareViewLabel() {
        viewLabel.text = "View more"
        viewLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        viewLabel.textColor = .secondary
        viewLabel.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
