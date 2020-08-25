import Foundation
import UIKit

class MockImageRepository: ImageRepositoryProtocol {
    
    let delay: Double
    
    init(delay: Double) {
        self.delay = delay
    }
    
    func get(imageFrom url: URL, withSize size: Float?, onSuccess: @escaping (UIImage) -> Void) -> URLSessionDataTask {
        let bundle = Bundle(for: MockImageRepository.self)
        let url = bundle.url(forResource: "placeHolder", withExtension: "jpg")!
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, _, _) in
            DispatchQueue.init(label: "delay", qos: .background).asyncAfter(deadline: .now() + self.delay) {
                self.processImage(data!, withSize: nil, onSuccess: onSuccess)
            }
        }
        task.resume()
        return task
    }
}
