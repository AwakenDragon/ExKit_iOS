//
//  UITableViewExtenstions.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/22.
//

import UIKit


public extension UITableView {
    func register<T: UITableViewHeaderFooterView>(nibWithHeaderFooterClass name: T.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: String(describing: name), bundle: bundle), forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
}
