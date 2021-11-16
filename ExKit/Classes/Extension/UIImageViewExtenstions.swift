//
//  UIImageViewExtenstions.swift
//  ExKit
//
//  Created by 周玉震 on 2021/10/9.
//

import UIKit
import Kingfisher
import RxSwift

public extension UIImageView {

    func setImage(with url: String?, placeholder: UIImage? = nil) {
        guard url != nil, !url!.isEmpty else {
            self.image = placeholder
            return
        }
        var Url = URL(string: url!)
        if Url == nil {
            if let queryUrl = url!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                Url = URL(string: queryUrl)
            }
        }
        
        self.setImage(with: Url, placeholder: placeholder)
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        guard url != nil else {
            self.image = placeholder
            return
        }
        self.kf.setImage(with: ImageResource(downloadURL: url!), placeholder: placeholder)
    }
}


public extension Reactive where Base: UIImageView {
    
    public func imageURL(_ placeholder: UIImage? = nil) -> Binder<String?> {
        return Binder(self.base) { imageView, image -> Void in
            if let url = image {
                imageView.setImage(with: url, placeholder: placeholder)
            } else {
                imageView.image = placeholder
            }
        }
    }
}
