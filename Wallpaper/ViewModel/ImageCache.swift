//
//  ImageCache.swift
//  Wallpaper
//
//  Created by Kalman on 2024/10/9.
//

import Foundation
import UIKit

class ImageCache{
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func set(_ image:UIImage,forKey key: String){
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String)-> UIImage?{
        return cache.object(forKey: key as NSString)
    }
}
