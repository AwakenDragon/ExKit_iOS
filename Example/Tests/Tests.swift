import XCTest
import ExKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        let s = "abcdefg"
        
        XCTAssert(s.substring(to: 2) == "abc", "Pass")
        XCTAssert(s.substring(from: 2) == "cdefg", "Pass")
    }
    
    func testPerformanceExample() {
        self.measure() {
            
        }
    }
}
