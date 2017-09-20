//
//  ViewController.swift
//  klStringUtilities-Demo
//
//  Created by Ken Laws on 5/25/17.
//  Copyright © 2017 dela. All rights reserved.
//

import UIKit
import klStringUtilities

struct klKeyboardParts {
	var height:CGFloat
	var rate:TimeInterval
}


class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

	@IBOutlet weak var scrollBottom: NSLayoutConstraint!
	@IBOutlet weak var lenInput: UITextField!
	@IBOutlet weak var lenResult: UILabel!
	@IBOutlet weak var autoTrimInput: UITextView!
	@IBOutlet weak var autoTrimResult: UILabel!
	@IBOutlet weak var locInput: UITextField!
	@IBOutlet weak var locResult: UILabel!
	@IBOutlet weak var fLocInput1: UITextField!
	@IBOutlet weak var fLocInput2: UITextField!
	@IBOutlet weak var fLocResult: UILabel!


	override func viewWillAppear(_ animated: Bool) {
		evaluateLen(input: lenInput.text!)
		evaluateAutoTrim(input: autoTrimInput.text!)
		evaluateLoc(input: locInput.text!)
		evaluateFLoc(input: "Item %1, item %2", p1: fLocInput1.text!, p2: fLocInput2.text!)

		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.keyboardWillBeShown(notification:)),
		                                       name: .UIKeyboardWillShow,
		                                       object: nil)

		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.keyboardWillBeShown(notification:)),
		                                       name: .UIKeyboardWillChangeFrame,
		                                       object: nil)

		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.keyboardWillBeHidden(notification:)),
		                                       name: .UIKeyboardWillHide,
		                                       object: nil)
	}


	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let txtAfterUpdate = String(textField.text!.replacingCharacters(in: textField.text!.rangeFromNSRange(nsRange: range)!, with: string))

		switch textField {
		case lenInput:
			self.evaluateLen(input: txtAfterUpdate)
		case locInput:
			self.evaluateLoc(input: txtAfterUpdate)
		case fLocInput1:
			self.evaluateFLoc(input: "Item %1, item %2", p1: txtAfterUpdate, p2: fLocInput2.text!)
		case fLocInput2:
			self.evaluateFLoc(input: "Item %1, item %2", p1: fLocInput1.text!, p2: txtAfterUpdate)
		default:
			break
		}
		return true
	}


	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let txtAfterUpdate = String(textView.text!.replacingCharacters(in: textView.text!.rangeFromNSRange(nsRange: range)!, with: text))

		switch textView {
		case autoTrimInput:
			self.evaluateAutoTrim(input: txtAfterUpdate)
		default:
			break
		}
		return true
	}


	func evaluateLen(input: String) {
		lenResult.text = "\(input.count) characters, \(input.characters.count) human characters"

	}


	func evaluateAutoTrim(input: String) {
		autoTrimResult.text = "\"\(input.autoTrim)\""
	}


	func evaluateLoc(input: String) {
		locResult.text = input.loc
	}


	func evaluateFLoc(input: String, p1: String, p2: String) {
		fLocResult.text = input.floc(p1, p2)
	}


	@objc func keyboardWillBeShown(notification: NSNotification) {
		guard let kbInfo = keyboardParts(info: notification.userInfo) else { return }

		scrollBottom.constant = kbInfo.height
		let anim = UIViewPropertyAnimator(duration: kbInfo.rate, curve: .easeOut) {
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}


	@objc func keyboardWillBeHidden(notification: NSNotification) {
		guard let kbInfo = keyboardParts(info: notification.userInfo) else { return }

		scrollBottom.constant = 0

		let anim = UIViewPropertyAnimator(duration: kbInfo.rate, curve: .easeOut) {
			self.view.layoutIfNeeded()
		}
		anim.startAnimation()
	}

	
	func keyboardParts(info: [AnyHashable : Any]?) -> klKeyboardParts? {
		guard let info = info else { return nil	}
		var parts = klKeyboardParts(height: 0, rate: 0)
		if let rect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			parts.height = rect.height
		}
		if let rate = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
			parts.rate = rate
		}



		return parts
	}


}

