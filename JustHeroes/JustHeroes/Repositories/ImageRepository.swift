import Foundation
import UIKit

enum ImageError: Error {
    case badData
    case noFaceFound
    case unknow
}

protocol ImageRepositoryProtocol {
    func get(imageFrom urlString: String, withSize size: Float?, onSuccess: @escaping (UIImage) -> Void) -> URLSessionDataTask
}

public class ImageRepository {
    
    static let shared = ImageRepository()
    
    public init() {}
    
    let queue = DispatchQueue(label: "image_decode_queue")
    
    var urlConfiguration: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60 * 60
        config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        return config
    }
    
    func get(imageFrom url: URL, withSize size: Float?, onSuccess: @escaping (UIImage) -> Void) -> URLSessionDataTask {
        let task = getImageTask(url, onSuccess: { [weak self] data in
            self?.processImage(data, withSize: size, onSuccess: onSuccess)
        }) { error in
            //TODO: onError image
        }
        getImageFromCache(forTask: task, onSuccess: { [weak self] data in
            self?.processImage(data, withSize: size, onSuccess: onSuccess)
        }) { [weak self]  in
            self?.queue.async {
                task.resume()
            }
        }
        return task
    }
    
    private func processImage(_ imageData: Data, withSize size: Float?, onSuccess: @escaping (UIImage) -> Void) {
        do {
           if let size = size {
               let image = try self.downsampleImage(fromData: imageData, maxSize: size)
               return onSuccess(image)
           }
        } catch {
           print("👾", "Error downsampling the image")
        }
        if let originalImage = UIImage(data: imageData) {
           onSuccess(originalImage)
        }
    }
    
    private func getImageFromCache(
        forTask task: URLSessionDataTask,
        onSuccess: @escaping (Data) -> Void,
        onFail: @escaping () -> Void) {
        URLCache.shared.getCachedResponse(for: task) { (response) in
            if let cachedResponse = response {
                print("👾", "Response from Cache!")
                onSuccess(cachedResponse.data)
            } else {
                onFail()
            }
        }
    }
    
    private func getImageTask(_ url: URL, onSuccess: @escaping (Data) -> (), onError: ((Error) -> ())?) -> URLSessionDataTask {
        let session = URLSession(configuration: self.urlConfiguration)
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            if let data = data {
                onSuccess(data)
            } else if let error = error {
                onError?(error)
            }
        }
        return session.dataTask(with: url, completionHandler: completionHandler)
    }
    
    private func downsampleImage(fromData data: Data, maxSize: Float) throws -> UIImage {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
            throw ImageError.badData
        }
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways:true,
                                 kCGImageSourceThumbnailMaxPixelSize:maxSize,
                                 kCGImageSourceShouldCacheImmediately:true,
                                 kCGImageSourceCreateThumbnailWithTransform:true,
                                 ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
            throw ImageError.badData
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}
