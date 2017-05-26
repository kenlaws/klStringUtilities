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
	
	var len: Int {
		var count = 0
		self.enumerateSubstrings(in: self.startIndex ..< self.endIndex, options: .byComposedCharacterSequences) { (_, _, _, _) in
			count += 1
		}

		return count
	}


	var autoTrim: String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}
	

	var loc:String {
		return NSLocalizedString(self, comment: "")
	}


	func floc(_ params: Any...) -> String {
		var formatted = self.loc
		for i in 1...params.count {
			formatted = formatted.replacingOccurrences(of: "%\(i)", with: String(describing: params[i-1]))
		}
		return formatted
	}

	
	func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
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
	var intString:String {
		let rawStr = NumberFormatter.localizedString(from: self as! NSNumber, number: .none)
		guard let rawInt = StringUtilities.sharedInstance.numberFormatter.number(from: rawStr) else {
			return rawStr
		}
		return StringUtilities.sharedInstance.numberFormatter.string(from: rawInt)!
	}
}


public extension BinaryFloatingPoint {
	var currencyString:String {
		if self.truncatingRemainder(dividingBy: 1) == 0 {
			return StringUtilities.sharedInstance.roundCurrencyFormatter.string(from: self as! NSNumber)!
		} else {
			return StringUtilities.sharedInstance.specificCurrencyFormatter.string(from: self as! NSNumber)!
		}
	}
}


public extension NSRange {
	init(string:String, range:Range<String.Index>) {
		let startPoint = string.distance(from: string.startIndex, to: range.lowerBound)
		let lenPoint = string.distance(from: range.lowerBound, to: range.upperBound)
		self = NSRange(location: startPoint, length: lenPoint)
	}
}




