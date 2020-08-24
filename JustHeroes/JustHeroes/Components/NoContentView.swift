import UIKit
import SnapKit

class NoContentView: UIView {

    var imageView: UIImageView
    
    init() {
        guard let image = UIImage(named: "noContent") else {
            fatalError("missing image")
        }
        imageView = UIImageView(image: image)
        super.init(frame: .zero)
    }

    override func draw(_ rect: CGRect) {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.rounded()
        
        super.draw(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
