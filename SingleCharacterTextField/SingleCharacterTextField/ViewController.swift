//
//  ViewController.swift
//  SingleCharacterTextField
//
//  Created by Mihir Luthra on 12/08/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var tf: SingleCharacterTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tf.singleCharacterDelegate = self
	}
}

extension ViewController: SingleCharacterTextFieldDelegate {
	func didAddCharacter(_ textField: SingleCharacterTextField, character: String) {
		print(#function, "Added character \(character)")
		print("Value of textField.character = \(textField.character)")
		separator()
	}
	
	func didAddCharacterWithOverflow(_ textField: SingleCharacterTextField, character: String, overflowedString: String) {
		print(#function, "Added character = \(character) with overflow = \(overflowedString)")
		print("Value of textField.character = \(textField.character)")
		separator()
	}
	
	func didBecomeEmpty(_ textField: SingleCharacterTextField, oldValue: String) {
		print("Became empty from \(oldValue)")
		print("Value of textField.character = \(textField.character)")
		separator()
	}
	
	func didUnderflow(_ textField: SingleCharacterTextField) {
		print(#function)
		print("Value of textField.character = \(textField.character)")
		separator()
	}
	
}


func separator() {
	print("*********************\n")
}
