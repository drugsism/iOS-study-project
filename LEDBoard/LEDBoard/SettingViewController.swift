//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by Breeze on 2022/10/12.
//

import UIKit

protocol LEDBoardSettingDataDelegate: AnyObject {
	func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {

	@IBOutlet weak var textView: UITextField!
	
	@IBOutlet weak var yellowButton: UIButton!
	@IBOutlet weak var purpleButton: UIButton!
	@IBOutlet weak var greenButton: UIButton!
	
	@IBOutlet weak var blackButton: UIButton!
	@IBOutlet weak var blueButton: UIButton!
	@IBOutlet weak var orangeButton: UIButton!
	
	var ledText: String?
	var chooseTextColor: UIColor = .yellow
	var chooseBackgroundColor: UIColor = .black
	
	weak var delegate: LEDBoardSettingDataDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.configureView()
    }
	
	private func configureView() {
		if let ledtext = self.ledText {
			self.textView.text = ledtext
		}
		changeTextColor(color: chooseTextColor)
		changeBackgoundColor(color: chooseBackgroundColor)
	}
    
	@IBAction func tabTextColorButton(_ sender: UIButton) {
		if sender == self.yellowButton {
			self.changeTextColor(color: .yellow)
		} else if sender == self.purpleButton {
			self.changeTextColor(color: .purple)
		} else if sender == self.greenButton {
			self.changeTextColor(color: .green)
		}
	}
	
	@IBAction func tabBackgoroundColorButton(_ sender: UIButton) {
		if sender == self.blackButton {
			self.changeBackgoundColor(color: .black)
		} else if sender == self.blueButton {
			self.changeBackgoundColor(color: .blue)
		} else if sender == self.orangeButton {
			self.changeBackgoundColor(color: .orange)
		}
	}
	@IBAction func saveButtonClicked(_ sender: UIButton) {
		self.delegate?.changedSetting(
			text: self.textView.text,
			textColor: self.chooseTextColor,
			backgroundColor: self.chooseBackgroundColor
		)
		
		self.navigationController?.popViewController(animated: true)
	}
	
	private func changeTextColor(color: UIColor) {
		self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
		self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
		self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
		
		chooseTextColor = color
	}
	
	private func changeBackgoundColor(color: UIColor) {
		self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
		self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
		self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
		
		chooseBackgroundColor = color
	}
	
}
