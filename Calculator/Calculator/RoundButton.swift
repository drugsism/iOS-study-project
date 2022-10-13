//
//  RoundButton.swift
//  Calculator
//
//  Created by Breeze on 2022/10/12.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
 	@IBInspectable var isRound: Bool = false {
		didSet {
			if isRound {
				self.layer.cornerRadius = self.frame.height / 2
			}
		}
	}

}
