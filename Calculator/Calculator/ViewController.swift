//
//  ViewController.swift
//  Calculator
//
//  Created by Breeze on 2022/10/12.
//

import UIKit

enum Operation {
	case Add
	case Subtract
	case Divide
	case Multiply
	case UnKnown
}

class ViewController: UIViewController {
	@IBOutlet weak var numberOuputLabel: UILabel!
	
	var displayNumber = ""
	var firstOperand = ""
	var secondOperand = ""
	var result = ""
	var currentOperation: Operation = .UnKnown
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}


	@IBAction func tabNumberButton(_ sender: UIButton) {
		guard let numberValue = sender.title(for: .normal) else { return }
		
		if self.displayNumber.count < 9 {
			self.displayNumber += numberValue
			self.numberOuputLabel.text = self.displayNumber
		}
	}
	
	@IBAction func tabClearButton(_ sender: UIButton) {
		numberOuputLabel.text = "0"
		self.displayNumber = ""
		self.currentOperation = .UnKnown
		self.firstOperand = ""
		self.secondOperand = ""
		self.result = ""
		
	}
	
	@IBAction func tabDotButton(_ sender: UIButton) {
		if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
			self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
			self.numberOuputLabel.text = self.displayNumber
		}
	}
	
	@IBAction func tabDivideButton(_ sender: UIButton) {
		self.operation(.Divide)
	}
	
	@IBAction func tabMutipleButton(_ sender: UIButton) {
		self.operation(.Multiply)
	}
	
	@IBAction func tabMinusButton(_ sender: UIButton) {
		self.operation(.Subtract)
	}
	
	@IBAction func tabPlusButton(_ sender: UIButton) {
		self.operation(.Add)
	}
	
	@IBAction func tabEqualButton(_ sender: UIButton) {
		self.operation(self.currentOperation)
	}
	
	func operation(_ operation: Operation) {
		if self.currentOperation != .UnKnown {
			
			if !self.displayNumber.isEmpty {
				self.secondOperand = self.displayNumber
				self.displayNumber = ""
				
				guard let firstOperand = Double(self.firstOperand) else { return }
				guard let secondOperand = Double(self.secondOperand) else { return }
				
				switch self.currentOperation {
				case .Add:
					self.result = "\(firstOperand + secondOperand)"
				case .Subtract:
					self.result = "\(firstOperand - secondOperand)"
				case .Multiply:
					self.result = "\(firstOperand * secondOperand)"
				case .Divide:
					self.result = "\(firstOperand / secondOperand)"
				default:
					break
				}
				
				if let result = Double(self.result),
					result.truncatingRemainder(dividingBy: 1) == 0 {
					self.result = "\(Int(result))"
				}
				
				self.firstOperand = self.result
				self.numberOuputLabel.text = self.result
			} else if self.displayNumber == "." {
				self.displayNumber = "0."
			}
		
			self.currentOperation = operation
		
		} else {
			self.firstOperand = self.displayNumber
			self.currentOperation = operation
			self.displayNumber = ""
			
		}
	}
}

