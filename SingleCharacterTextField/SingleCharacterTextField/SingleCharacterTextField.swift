//
//  SingleCharacterTextField.swift
//  SingleCharacterTextField
//
//  Created by Mihir Luthra on 12/08/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit

protocol SingleCharacterTextFieldDelegate {
	///Triggered when text field was already empty and backspace was pressed.
	func didUnderflow(_ textField: SingleCharacterTextField)
	
	///Triggered when a character is added.
	func didAddCharacter(_ textField: SingleCharacterTextField, character: String)
	
	///Triggered when text was added with an overflow. This can occur in cases of changing `character` property by code or when a string
	///of more than 1 character is copy-pasted.
	func didAddCharacterWithOverflow(_ textField: SingleCharacterTextField, character: String, overflowedString: String)
	
	///Triggered when text field was made empty
	///- Parameter oldValue: Value before textField became empty
	func didBecomeEmpty(_ textField: SingleCharacterTextField, oldValue: String)
}

/**
SingleCharacterTextField only allows one character in it.
In cases of overflow/underflow, it reports to its delegate which is set
by property `singleCharacterDelegate`.
With this, `text` property of UITextField must **NOT** be modified directly in
code. Use `character` property instead of `text`.
*/
class SingleCharacterTextField: UITextField {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	/**
	This is the value assigned to `character`.
	If it wasn't a getter it would return this.
	For example,
	if character is set as following,
	textField.character = "123"
	`characterValue` would also be set to "123".
	
	As character is a getter, it would return "1" instead.
	*/
	var characterValue: String = ""
	
	/// Use this instead of `text` to set contents of the text field.
	var character: String {
		get {
			return text!
		}
		set {
			if newValue.count == 1 {
				text = newValue
				singleCharacterDelegate?.didAddCharacter(self, character: newValue)
			} else if newValue.count > 1 {
				let newCharacter = String(newValue.first!)
				text = newCharacter
				let index = newValue.index(after: newValue.startIndex)
				singleCharacterDelegate?.didAddCharacterWithOverflow(self, character: newCharacter, overflowedString: String(newValue[index...]))
			} else {
				text = newValue
				if let firstCharacter = characterValue.first {
					singleCharacterDelegate?.didBecomeEmpty(self, oldValue: String(firstCharacter))
				} else {
					singleCharacterDelegate?.didBecomeEmpty(self, oldValue: "")
				}
			}
			
			characterValue = newValue
		}
	}

	var singleCharacterDelegate: SingleCharacterTextFieldDelegate?

	private func setup() {
		self.addTarget(self, action: #selector(textFieldEdited(_:)), for: .editingChanged)
	}
	 
	@objc private func textFieldEdited(_ textField: UITextField) {
		character = text!
	}

	override func deleteBackward() {
		/*
		This function is called by UITextField to delete a character.
		If the text before calling this is "", it is called an underflow
		for SingleCharacterTextField and is notified to delegate.
		*/
		
		let underflow = text == "" ? true : false
		super.deleteBackward()
		if underflow {
			singleCharacterDelegate?.didUnderflow(self)
		}
	}
}

