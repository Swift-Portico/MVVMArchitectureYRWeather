//
//  Protocols.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 02/11/21.
//

import Foundation
import UIKit


protocol CollectionReusable {}

/// MARK:- UITableView

extension CollectionReusable where Self: UITableViewCell  {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CollectionReusable {}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return cell
    }
}
