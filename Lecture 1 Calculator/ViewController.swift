//
//  ViewController.swift
//  Lecture 1 Calculator
//
//  Created by Konstantin Konstantinov on 4/14/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var sequenceOfOperations: UILabel!
    
    /// Calculator's model
    private var brain = CalculatorBrain()
    
    var userIsInTheMiddleOfTyping = false
    
    /// Informs that equal or binary operation button has been just pressed
    var equalOrBinaryOperationButtonIsPressed = false
    
    /// Digit button touch implementation
    @IBAction func digitTouch(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            if !(digit == "." && display.text!.contains(".")) {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    /// Value that shows on calculator's main display
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    /// Operation button touch implementation
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
        if let description = brain.description {
            sequenceOfOperations.text = description + (brain.resultIsPending ? "…" : "=")
        } else {
            sequenceOfOperations.text = ""
        }
    }
    
    /// Clear button touch implementation
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain.clearCalculator()
        display.text = "0"
        sequenceOfOperations.text = ""
    }
    
}

