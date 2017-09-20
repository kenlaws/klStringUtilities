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
		numberFormatter.groupingSize = 3
		numberFormatter.usesGroupingSeparator = true
	}

}


public extension String {

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
		if let _ = self.range(of: regExString, options: options) {
			return true
		} else {
			return false
		}
	}


	/// Returns an array of Strings with RegEx capture groups found in the receiver.
	///
	/// - Parameter regExString: The search string. It's best to include at least one capture group
	/// - Returns: An array of Strings, starting with the complete match, followed by the found capture groups, or an empty array if no match was found, or nil if the regular expression failed to parse
	func withMatchingPatterns(regExString:String) -> [String]? {
		do {
			let regEx = try NSRegularExpression(pattern: regExString, options: .useUnicodeWordBoundaries)
			var results:[String] = []
			for item in regEx.matches(in: self, options: .withTransparentBounds, range: NSMakeRange(0, self.count)) {
				for i in 0..<item.numberOfRanges {
					if let rng = self.rangeFromNSRange(nsRange: item.range(at: i))  {
						results += [String(self[rng])]
					}
				}
			}
			return results
		} catch {
			return nil
		}
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




