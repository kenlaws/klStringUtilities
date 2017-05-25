//
//  klStringUtilitiesTests.swift
//  klStringUtilitiesTests
//
//  Created by Ken Laws on 5/24/17.
//  Copyright © 2017 Ken Laws. All rights reserved.
//

import XCTest
@testable import klStringUtilities

class klStringUtilitiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStrLen() {
		let t1 = "Hello."
		let ln1 = t1.len
		XCTAssert(ln1 == 6, "simple len test")
		
		let t2 = "Smile😁多谢"
		let ln2 = t2.len
		XCTAssert(ln2 == 8, "16 bit char len test")
    }
	
	func testAutoTrim() {
		let t1 = "hello"
		XCTAssert(t1.autoTrim == "hello", "negative autoTrim test")
		
		let t2 = "\n hello "
		XCTAssert(t2.autoTrim == "hello", "complex autoTrim test")
	}
    
	
}
