//
//  ImageService.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 7/25/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()

    static func downloadImage(withUrl url: URL, completion: @escaping (_ image: UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responseUrl, error) in
            var downloadedImage: UIImage?
            
            if let data = data  {
                downloadedImage = UIImage(data: data)
            }
            if downloadImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    static func getImage(withUrl url: URL, completion: @escaping (_ image: UIImage?)->()) {
        
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            
            downloadImage(withUrl: url, completion: completion)
            
        }
    }
    
}
