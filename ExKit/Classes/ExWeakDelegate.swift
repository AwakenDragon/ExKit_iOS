//
//  EXWeakDelegate.swift
//  ExKit
//
//  Created by 周玉震 on 2021/10/9.
//

import UIKit

public class ExWeakDelegate: NSObject {
    public weak var delegate: NSObjectProtocol?
    
    public init(_ delegate: NSObjectProtocol) {
        self.delegate = delegate
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        var equal = super.isEqual(object)
        if let o = object as? ExWeakDelegate, !equal {
            equal = o.delegate?.isEqual(self.delegate) ?? false
        }
        return equal
    }
}
