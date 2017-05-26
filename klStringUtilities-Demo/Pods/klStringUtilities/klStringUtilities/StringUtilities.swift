//
//  StringUtilities.swift
//
//
//  Created by Ken Laws on 8/18/16.
//  Copyright © 2017 Ken Laws. All rights reserved.
//

import UIKit


public class StringUtilities {
	static let sharedInstance = StringUtilities()

	let roundCurrencyFormatter = NumberFormatter()
	let specificCurrencyFormatter = NumberFormatter()
	let numberFormatter = NumberFormatter()


	init() {
		specificCurrencyFormatter.numberStyle = .currency
		specificCurrencyFormatter.locale = NSLocale.current

		roundCurrencyFormatter.numberStyle = .currency
		roundCurrencyFormatter.maximumFractionDigits = 0
		roundCurrencyFormatter.locale = NSLocale.current

		numberFormatter.numberStyle = .none
		numberFormatter.usesGroupingSeparator = true
	}

}


public extension String {

	/// Shortcut for self.characters.count
	///
	/// - Returns: integer count of characters
	var len: Int {
		return self.characters.count
	}


	/// Counts the number of human-visible characters in a String. That is, multiple glyph characters are counted as one.
	///
	/// - Returns: integer count of human-visible characters
	var humanLen: Int {
		var count = 0
		self.enumerateSubstrings(in: self.startIndex ..< self.endIndex, options: .byComposedCharacterSequences) { (_, _, _, _) in
			count += 1
		}

		return count
	}


	/// A quick shortcut to remove any whitespace chars from the start and end of a string.
	///
	/// - Returns: the String, stripped of leading and trailing whitespace
	var autoTrim: String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}


	/// Shortcut for localization. The String is run through NSLocalizedString.
	///
	/// - Returns: the result of the String being run through NSLocalizedString.
	var loc:String {
		return NSLocalizedString(self, comment: "")
	}


	/// Shortcut for localization. The string is run through NSLocalizedString with any '%' params replaced.
	///
	/// - Parameter params: one or more parameters to replace the '%' placeholders
	/// - Returns: the result of the string from NSLocalizedString with the included params
	func floc(_ params: Any...) -> String {
		var formatted = self.loc
		for i in 1...params.count {
			formatted = formatted.replacingOccurrences(of: "%\(i)", with: String(describing: params[i-1]))
		}
		return formatted
	}


	/// Convert an NSRange into a Swift range
	///
	/// - Parameter nsRange: the NSRange to convert. If the range is out of bounds of the string, the function will return nil
	/// - Returns: returns the Swift range, or nil if the NSRange was outside the bounds of the String
	func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
		guard
			let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
			let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
			let from = from16.samePosition(in: self),
			let to = to16.samePosition(in: self)
			else { return nil }
		return from ..< to
	}


	/// Convert an NSRange taking into account multi-glyph characters
	///
	/// - Parameter nsRange: the NSRange to convert
	/// - Returns: the Swift range, always on the border of a complete complex character. Note that it will return nil if the range is outside the bounds of the human range of characters
	func humanRangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
		var charCount = 0
		var fromRng:Range<String.Index>?
		var toRng:Range<String.Index>?
		self.enumerateSubstrings(in: self.startIndex ..< self.endIndex, options: .byComposedCharacterSequences) { (_, r1, _, stop) in
			if fromRng == nil {
				if charCount == nsRange.location {
					fromRng = r1
					if nsRange.length == 0 {
						toRng = r1
						stop = true
					}
				} else {
					charCount += 1
				}
			} else if toRng == nil {
				if charCount == nsRange.location + nsRange.length {
					toRng = r1
				}
				charCount += 1
			} else {
				stop = true
			}
		}

		guard let _ = fromRng, let _ = toRng else {
			return nil
		}

		return fromRng!.lowerBound ..< toRng!.lowerBound
	}


	/// Shortcut to find if a String contains a particular RegEx value.
	///
	/// - Parameters:
	///   - regExString: the regular expression to look for
	///   - ci: case insensitivity. Default is true
	/// - Returns: a Bool indicating whether or not the RegEx was found
	func containsRegEx(regExString:String, ci:Bool = true) -> Bool {
		var options:NSString.CompareOptions = [.regularExpression]
		if ci {
			options = [options, NSString.CompareOptions.caseInsensitive]
		}
		guard let _ = self.range(of: regExString, options: .regularExpression) else {
			return true
		}
		return false
	}


	/// Returns an array of Strings with RegEx capture groups found in the receiver.
	///
	/// - Parameter regExString: The search string. It's best to include at least one capture group
	/// - Returns: An array of Strings with the found capture groups, or nil of the search string was not found
	func withMatchingPatterns(regExString:String) -> [String]? {
		let regEx = try! NSRegularExpression(pattern: regExString, options: .useUnicodeWordBoundaries)
		var results:[String] = []
		for item in regEx.matches(in: self, options: .withTransparentBounds, range: NSMakeRange(0, self.len)) {
			if NSEqualRanges(item.range, NSMakeRange(NSNotFound, 0)) {
				return nil
			}
			for i in 1..<item.numberOfRanges {
				if let rng = self.rangeFromNSRange(nsRange: item.rangeAt(i))  {
					results += [self.substring(with: rng)]
				}
			}
		}

		return results
	}

}


public extension ExpressibleByIntegerLiteral {
	/// Returns a string rounded to the nearest Int, with localized grouping separators (i.e., ',') if appropriate.
	var intString:String {
		let rawStr = NumberFormatter.localizedString(from: self as! NSNumber, number: .none)
		guard let rawInt = StringUtilities.sharedInstance.numberFormatter.number(from: rawStr) else {
			return rawStr
		}
		return StringUtilities.sharedInstance.numberFormatter.string(from: rawInt)!
	}
}


public extension BinaryFloatingPoint {
	/// Returns a string formatted for the local currency, rounded off if passed a whole number.
	var currencyString:String {
		if self.truncatingRemainder(dividingBy: 1) == 0 {
			return StringUtilities.sharedInstance.roundCurrencyFormatter.string(from: self as! NSNumber)!
		} else {
			return StringUtilities.sharedInstance.specificCurrencyFormatter.string(from: self as! NSNumber)!
		}
	}
}


public extension NSRange {
	/// Creates an NSRange from a Swift String range
	///
	/// - Parameters:
	///   - string: the source String
	///   - range: the source Range
	init(string:String, range:Range<String.Index>) {
		let startPoint = string.distance(from: string.startIndex, to: range.lowerBound)
		let lenPoint = string.distance(from: range.lowerBound, to: range.upperBound)
		self = NSRange(location: startPoint, length: lenPoint)
	}
}




