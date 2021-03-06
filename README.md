klStringUtilities
=================

A small set of Swift 3 utilities I've come up with over the last few months, sometimes via Googling, sometimes on my own. Feel free to use them if you have a need for one or more of these shortcuts.

## Current Version: 1.0.5
This version is for Swift 4. I removed the length-based stuff, as that now works "as it should" in Swift 4. If you need the Swift 3 version, specify 1.0.4 in your Podfile.

## Installation
### [CocoaPods](http://cocoapods.org/)

1. Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

    ```
    use_frameworks! #if this isn't already in your podfile
    pod "klStringUtilities"
    ```
2. Run `pod install`.
3. Enjoy.

## Documentation
Until I have ample time, note that you can find at least simple examples of usage in both the Demo app and the `klStringUtilities_iOSTests` class.
### Extensions to String
#### `.autoTrim: String`
A quick shortcut to remove any whitespace chars from the start and end of a string.  
**Returns:** the String, stripped of leading and trailing whitespace  

#### `.loc: String`
Shortcut for localization. The String is run through NSLocalizedString.  
**Returns:** the result of the String being run through NSLocalizedString  

#### `.floc(_ params: Any...) -> String`
Shortcut for localization. The string is run through NSLocalizedString with any '%' params replaced.  
**Parameter** *params*: one or more parameters to replace the '%' placeholders  
**Returns:** the result of the String being run through NSLocalizedString  

#### `func rangeFromNSRange(nsRange: NSRange) -> Range<String.Index>?`
Convert an NSRange into a Swift range.  
**Parameter** *nsRange*: the NSRange to convert. If the range is out of bounds of the string, the function will return nil  
**Returns:** returns the Swift range, or nil if the NSRange was outside the bounds of the String  

#### `func containsRegEx(regExString:String, ci:Bool = true) -> Bool`
Shortcut to find if a String contains a particular RegEx value.
**Parameters**  
*regExString*: the regular expression to look for  
*ci*: case insensitivity. Default is true  
**Returns:** a Bool indicating whether or not the RegEx was found  

#### `func withMatchingPatterns(regExString:String) -> [String]?`
Returns an array of Strings with RegEx capture groups found in the receiver.  
**Parameter** *regExString*: the regular expression to look for  
**Returns:** An array of Strings, starting with the complete match, followed by the found capture groups, or an empty array if no match was found, or nil if the regular expression failed to parse  

### Extensions to ExpressibleByIntegerLiteral
#### `.intString:String`
Returns a string rounded to the nearest Int, with localized grouping separators (i.e., ',') if appropriate.  

### Extensions to BinaryFloatingPoint
#### `.currencyString:String`
Returns a string formatted for the local currency, rounded off if passed a whole number.  

### Extensions to NSRange
#### `init(string:String, range:Range<String.Index>)`
Creates an NSRange from a Swift String range.  
**Parameters**  
*string*: the source String  
*range*: the source Range  


