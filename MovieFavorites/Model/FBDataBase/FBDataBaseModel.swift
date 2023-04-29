//
//  FBDataBaseModel.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/04/17.
//

import Foundation
import UIKit

struct FBDataBase {
    
    
    let appVersion: Double
    var isForcedUpdate: Bool
    
    init?(value: [String:Any]) {
        guard let appVersion = value["appVersion"] as? Double else { return nil }
        guard let isForcedUpdate = value["isForcedUpdate"] as? Bool else { return nil }
        
        self.appVersion = appVersion
        self.isForcedUpdate = isForcedUpdate
    }
    
    
}
