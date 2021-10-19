//
//  Extensions.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.visibleVC(vc: self.rootViewController)
    }
    
    static func visibleVC(vc: UIViewController?) -> UIViewController? {
        if let navigationViewController = vc as? UINavigationController {
            return UIWindow.visibleVC(vc: navigationViewController.visibleViewController)
        } else if let tabBarVC = vc as? UITabBarController {
            return UIWindow.visibleVC(vc: tabBarVC.selectedViewController)
        } else {
            if let presentedVC = vc?.presentedViewController {
                return UIWindow.visibleVC(vc: presentedVC)
            } else {
                return vc
            }
        }
    }
}

public func visibleViewController() -> UIViewController? {
    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.visibleViewController
}
