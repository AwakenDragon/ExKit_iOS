//
//  StringExTests.swift
//  ExKit_Tests
//
//  Created by ZhouYuzhen on 2020/11/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import ExKit

class StringExTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSubscript() {
        let str = "abcdefg"
        XCTAssert(str[safe: 3] == "d", "Subscript Index Pass")
        XCTAssert(str[from: 3, len: 2] == "de", "Subscript [3, 2] Pass")
    }

    
    func testSubstring() {
        let s = "abcdefg"
        XCTAssert(s[to: 2] == "abc", "substring(to: 2) Pass")
        XCTAssert(s.substring(to: 2) == "abc", "substring(to: 2) Pass")
        XCTAssert(s[from: 2] == "cdefg", "substring(from: 2) Pass")
        XCTAssert(s.substring(from: 2) == "cdefg", "substring(from: 2) Pass")
    }
    
    func testMdString() {
        let s = "abc"
        XCTAssert(s.md2String() == "da853b0d3f88d99b30283a69e6ded6bb", "md2 Pass")
        XCTAssert(s.md4String() == "a448017aaf21d8525fc10ae87aa6729d", "md4 Pass")
        XCTAssert(s.md5String() == "900150983cd24fb0d6963f7d28e17f72", "md5 Pass")
    }
    
    func testPerformanceExample() {
        self.measure() {
            
        }
    }
}
