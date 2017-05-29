//
//  klStringUtilities_tvOSTests.swift
//  klStringUtilities-tvOSTests
//
//  Created by Ken Laws on 5/28/17.
//  Copyright © 2017 dela. All rights reserved.
//

import XCTest
@testable import klStringUtilities

class klStringUtilities_tvOSTests: XCTestCase {
    
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
	}

	func testStrLen16() {
		let t1 = "Smile😁多谢"
		let ln1 = t1.len
		XCTAssert(ln1 == 8, "16 bit char len test")
	}

	func testStrLenMultiGlyph() {
		let t1 = "Smile🏆📦🐈👍🏼👲🏽💂🏻‍♀️👶🏼"
		let ln1 = t1.len
		XCTAssert(ln1 == 17, "16 bit char len test")
	}

	func testStrHumanLenMultiGlyph() {
		let t1 = "Smile🏆📦🐈👍🏼👲🏽💂🏻‍♀️👶🏼"
		let ln1 = t1.humanLen
		XCTAssert(ln1 == 12, "multi glyph char human test")
	}

	func testAutoTrimNegative() {
		let t1 = "hello"
		XCTAssert(t1.autoTrim == "hello", "negative autoTrim test")
	}

	func testAutoTrimPositive() {
		let t1 = "\n hello "
		XCTAssert(t1.autoTrim == "hello", "complex autoTrim test")
	}

	func testBasicLoc() {
		let t1 = "Simple Example".loc
		XCTAssert(t1 == "This is a simple example of a localizable string.", "Result should be localized string, not \(t1)")
	}

	func testLocWithNoMatch() {
		let t1 = "Just a string".loc
		XCTAssert(t1 == "Just a string", "Result should be the source string, not \(t1)")
	}

	func testBasicFLoc() {
		let t1 = "Item %1, item %2".floc("i1", "i2")
		XCTAssert(t1 == "In this language, item i1 will happen first, followed by item i2.", "Result should be the localized string with parameters added, not \(t1)")
	}

	func testBasicRangeFromNSRange() {
		let t1 = "0123456789"
		let rng:Range<String.Index> = t1.index(t1.startIndex, offsetBy: 2) ..< t1.index(t1.startIndex, offsetBy: 4)
		let nRng = NSRange(location: 2, length: 2)
		let newRng = t1.rangeFromNSRange(nsRange: nRng)
		XCTAssert(rng == newRng, "The Swift range \(rng) should equal the NSRange \(nRng)")
	}

	func testRegExWithMatch() {
		let t1 = "This is a test string."
		let rx = "\\bt[aeiou]st\\b"
		XCTAssert(t1.containsRegEx(regExString: rx), "The RegEx string should match the target string. \(rx)")
	}


	func testRegExWithNoMatch() {
		let t1 = "This is a test string."
		let rx = "\\bt[aiou]st\\b"
		XCTAssert(!t1.containsRegEx(regExString: rx), "The RegEx string should NOT match the target string (missing e.) \(rx)")
	}

	func testRegExWithCSMatch() {
		let t1 = "this is a test string."
		let rx = "\\bTh[aeiou]s\\b"
		XCTAssert(!t1.containsRegEx(regExString: rx, ci: false), "The RegEx should not match due to case sensitivity. \(rx)")
	}

	func testMatchingPattern() {
		let t1 = "This is an emoji.name@kenlaws.com 👍🏼👲🏽 test string."
		let rx = "([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})"
		let result = t1.withMatchingPatterns(regExString: rx)
		var pass = false
		if let eName = result?[1], let domain = result?[2], let tDomain = result?[3] {
			pass = (eName == "emoji.name") && (domain == "kenlaws") && (tDomain == "com")
		}
		XCTAssert(pass, "The RegEx should produce a set of strings with the found email address broken down into component parts. \(rx)")
	}

	func testMatchingPatternBase() {
		let t1 = "This is an emoji.name@kenlaws.com 👍🏼👲🏽 test string."
		let rx = "com\\s*(.*?)\\s*test"
		let result = t1.withMatchingPatterns(regExString: rx)
		var pass = false
		if let base = result?[0], let emoji = result?[1] {
			pass = (base == "com 👍🏼👲🏽 test") && (emoji == "👍🏼👲🏽")
		}
		XCTAssert(pass, "The Regex should find the emoji between the space characters and return them as a group. \(rx)")
	}

	func testMatchingPatternNotFound() {
		let t1 = "This is an emoji.name@kenlaws.com 👍🏼👲🏽 test string."
		let rx = "Sir Not Appearing in This String"
		let result = t1.withMatchingPatterns(regExString: rx)!
		XCTAssert(result.count == 0, "The result should be an empty array, since there was no match. \(rx)")
	}

	func testMatchingPatternBadPattern() {
		let t1 = "This is an emoji.name@kenlaws.com 👍🏼👲🏽 test string."
		let rx = "All{screwed)up"
		let result = t1.withMatchingPatterns(regExString: rx)
		XCTAssert(result == nil, "The result should be nil, as the pattern is bad. \(rx)")
	}

	func testBasicIntString() {
		let t1 = 8554.6
		let result = t1.intString
		XCTAssert(result == "8,555", "The result should the number rounded with a separator. \(result)")
	}

	func testBasicCurrencyString() {
		let t1 = 8554.55
		let result = t1.currencyString
		XCTAssert(result == "$8,554.55", "The result should the number in dollars (for this test) with a separator.")
	}

	func testNSRangeFromRange() {
		let t1 = "0123456789"
		let rng:Range<String.Index> = t1.index(t1.startIndex, offsetBy: 2) ..< t1.index(t1.startIndex, offsetBy: 5)
		let nRng = NSRange(string: t1, range: rng)
		let testRng = NSRange(location: 2, length: 3)
		XCTAssert(NSEqualRanges(nRng, testRng), "The Swift range \(rng) should equal the NSRange \(nRng)")
	}
	
    
}
