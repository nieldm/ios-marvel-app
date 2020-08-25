import UIKit
import SnapKit

class NoContentView: UIView {

    var imageView: UIImageView
    var coverLayer: CALayer?
    
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
        loadingLayer(rect)
        super.draw(rect)
    }
    
    private func loadingLayer(_ rect: CGRect) {
        let coverLayer = CAShapeLayer()
        coverLayer.fillColor = UIColor.black.withAlphaComponent(0.85).cgColor
        coverLayer.path = UIBezierPath(rect: rect).cgPath
        
        let background = CAShapeLayer()
        background.fillColor = UIColor.white.cgColor
        background.path = createRandomPath(rect)
        background.fillRule = .evenOdd
        background.add(
            createPathAnimation(rect),
            forKey: "move"
        )
        
        let loadingText = createLoadingTextLayer(rect)
        loadingText.fadeInFadeOutAnimation()
        coverLayer.addSublayer(loadingText)
    
        coverLayer.mask = background
        layer.addSublayer(coverLayer)
        self.coverLayer = coverLayer
    }
    
    func changeSize(_ size: CGSize) {
        self.coverLayer?.removeFromSuperlayer()
        self.coverLayer = nil
        loadingLayer(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NoContentView {
    func createLoadingTextLayer(_ rect: CGRect) -> CALayer {
        let loadingText = CATextLayer()
        loadingText.string = "searching..."
        loadingText.fontSize = 32
        loadingText.foregroundColor = UIColor.white.cgColor
        loadingText.isWrapped = true
        loadingText.alignmentMode = .center
        loadingText.truncationMode = .end
        loadingText.contentsScale = UIScreen.main.scale
        loadingText.frame = CGRect(x: 0, y: rect.height * 0.85, width: rect.width, height: 44)
        return loadingText
    }
    
    func createPathAnimation(_ rect: CGRect) -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.values = (0..<10).map { _ in createRandomPath(rect) }
        animation.duration = 5.0
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    func createRandomPath(_ rect: CGRect) -> CGMutablePath {
        let randX = CGFloat.random(in: 0...(rect.width - 150))
        let randY = CGFloat.random(in: 0...(rect.height - 150))
        let randomPath = CGMutablePath()
        randomPath.addRect(rect)
        randomPath.addEllipse(in: CGRect(x: randX, y: randY, width: 150, height: 150))
        return randomPath
    }
}

private extension CALayer {
    func fadeInFadeOutAnimation() {
        let tryTextAnimation = CABasicAnimation(keyPath: "opacity")
        tryTextAnimation.fromValue = 1.0
        tryTextAnimation.toValue = 0
        tryTextAnimation.duration = 0.75
        tryTextAnimation.timingFunction = .init(name: .easeInEaseOut)
        tryTextAnimation.repeatCount = .infinity
        tryTextAnimation.autoreverses = true
        self.add(tryTextAnimation, forKey: "fadeInFadeOut")
    }
}
