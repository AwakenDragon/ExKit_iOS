//
//  UIApplicationExtenstions.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/18.
//

import UIKit

public extension UIApplication {
    var isSupportMultipleScenes: Bool {
        if #available(iOS 13.0, *) {
            return supportsMultipleScenes
        } else {
            return false
        }
    }
    
    var exApp: ExApp? {
        UIApplication.shared.delegate as? ExApp
    }
}
