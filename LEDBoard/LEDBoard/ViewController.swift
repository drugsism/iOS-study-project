//
//  ViewController.swift
//  LEDBoard
//
//  Created by Breeze on 2022/10/11.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDataDelegate {
	
	

	@IBOutlet weak var contentsLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.contentsLabel.textColor = .yellow
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let settingViewController = segue.destination as? SettingViewController {
			settingViewController.delegate = self
			settingViewController.ledText = self.contentsLabel.text
			settingViewController.chooseTextColor = self.contentsLabel.textColor ?? .yellow
			settingViewController.chooseBackgroundColor = self.view.backgroundColor ?? .black
//
		}
	}
	
	

	func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) {
		if let text = text {
			self.contentsLabel.text = text
		}
		self.contentsLabel.textColor = textColor
		self.view.backgroundColor = backgroundColor
		
	}
}

