//
//  UIWindowExtenstions.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/18.
//

import UIKit

public extension UIWindow {
    static var currentWindow: UIWindow {
        var window: UIWindow!
        if UIApplication.shared.isSupportMultipleScenes {
            let windows = UIApplication.shared.windows
            window = windows.filter { $0.isKeyWindow }.first
            if window.windowLevel != UIWindow.Level.normal {
                window = windows.filter { $0.windowLevel == UIWindow.Level.normal }.first
            }
        } else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
    
    static var currentController: UIViewController {
        return getTopViewController(currentWindow.rootViewController!)
    }
    
    static func getTopViewController(_ controller: UIViewController) -> UIViewController {
        if let presentVC = controller.presentedViewController {
            return getTopViewController( presentVC)
        } else if let selectVC = (controller as? UITabBarController)?.selectedViewController {
            return getTopViewController(selectVC)
        } else if let visibleVC = (controller as? UINavigationController)?.visibleViewController {
            return getTopViewController(visibleVC)
        } else {
            return controller
        }
    }
    
}
