//
//  ImageCasheManager.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/29.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
}
