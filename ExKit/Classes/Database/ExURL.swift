//
//  ExURL.swift
//  ExKit
//
//  Created by 周玉震 on 2021/8/18.
//

import Foundation
import RealmSwift

public struct ExURL {
    public var key: String!
    public var value: String!
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

class ExURLObj: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""
}
