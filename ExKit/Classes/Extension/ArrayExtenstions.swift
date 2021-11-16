//
//  ArrayEx.swift
//  ExKit
//
//  Created by 周玉震 on 2021/1/15.
//

import Foundation

public extension Array {
    ///  ExKit: 获取指定范围的数组
    ///
    ///  ```
    ///  let array = ["a", "b", "c", "d", "e", "f", "g"]
    ///  let d = array[from: 3, len: 2] // d = ["d", "e"]
    ///  ```
    ///
    ///  - parameter index: 指定开始位置，必须大于等于0且小于字符串本身长度 - 1
    ///  - parameter length: 指定Array长度，必须大于0
    ///  - returns: String
    subscript(from index: Int, len length: Int) -> Array? {
        Array(self[index ..< index + length])
    }


    /// ExKit: 截取到指定位置的数组
    ///
    ///  ```
    ///  let array = ["a", "b", "c", "d", "e", "f", "g"]
    ///  let d = array[to: 3] // d = ["a", "b", "c", d"]
    ///  ```
    ///
    ///  - parameter index : 结束位置（包含）
    ///  - returns : 截取Array
    subscript(to index: Int) -> Array? {
        Array(self[0 ... (index >= self.count ? self.count - 1 : index)])
    }
    
    ///  ExKit: 截取到指定位置的字符串
    ///
    ///  ```
    ///  let array = ["a", "b", "c", "d", "e", "f", "g"]
    ///  let d = array[from: 3] // d = ["d", "e", "f", "g"]
    ///  ```
    ///
    ///  - parameter from: 开始位置（包含）
    ///  - returns : Array
    subscript(from index: Int) -> Array? {
        Array(self[(index < 0 ? 0 : index) ..< self.count])
    }
}
