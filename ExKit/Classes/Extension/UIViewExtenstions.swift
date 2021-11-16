//
//  UIViewExtenstions.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/20.
//

import UIKit
import SwifterSwift

public protocol ExNibLoadable {
    static var nibBundle: Bundle? { get }
    static var nibName: String? { get }
}

public extension ExNibLoadable {
    static var nibBundle: Bundle? { return nil}
    static var nibName: String? { return nil }
    static func loadFromNib() -> Self? {
        let name = nibName ?? String(describing: self)
        return UIView.loadFromNib(named: name, bundle: nibBundle) as? Self
    }
    
    static func loadNib() -> UINib {
        let name = nibName ?? String(describing: self)
        return UINib(nibName: name, bundle: nibBundle)
    }
}

public extension UIView {
    static let EX_COMMON_PADDING_BIG: CGFloat = 20
    static let EX_COMMON_PADDING_NORMAL: CGFloat = 15
    static let EX_COMMON_PADDING_SMALL: CGFloat = 10

    static let EX_COMMON_SPACE_BIG: CGFloat = 15
    static let EX_COMMON_SPACE_NORMAL: CGFloat = 10
    static let EX_COMMON_SPACE_SMALL: CGFloat = 5
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
        let maskPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
