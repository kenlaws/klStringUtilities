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
		return self.characters.count
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
	
	
	var formatAsUSPhone: String {
		var filtered = (self.characters.filter{["+","0","1","2","3","4","5","6","7","8","9"].contains($0)})
		if filtered.count < 6 {
			//too short
			return self
		}

		if filtered[0] == "+" && filtered[1] != "1" {
			//country code, not US
			return self
		}

		if String(filtered[0...1]) == "+1" {
			filtered.removeFirst(2)
		}

		if filtered.count < 10 {
			//we somehow failed
			return self
		}

		var result = "(" + String(filtered[0...2]) + ") "
		result += String(filtered[3...5])
		result += "-" + String(filtered[6...9])

		return result
	}
	
	
	static func formattedInt(from:Double) -> String {
		return StringUtilities.sharedInstance.numberFormatter.string(from: from as NSNumber)!
	}
	
	
	static func currency(from:Double) -> String {
		if from.truncatingRemainder(dividingBy: 1) == 0 {
			return StringUtilities.sharedInstance.roundCurrencyFormatter.string(from: from as NSNumber)!
		} else {
			return StringUtilities.sharedInstance.specificCurrencyFormatter.string(from: from as NSNumber)!
		}
	}


	func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
		guard
			let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
			let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
			let from = from16.samePosition(in: self),
			let to = to16.samePosition(in: self)
			else { return nil }
		return from ..< to
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


public extension NSRange {
	init(string:String, range:Range<String.Index>) {
		let startPoint = string.distance(from: string.startIndex, to: range.lowerBound)
		let lenPoint = string.distance(from: range.lowerBound, to: range.upperBound)
		self = NSRange(location: startPoint, length: lenPoint)
	}
}




