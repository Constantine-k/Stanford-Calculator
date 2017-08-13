//
//  ViewController.swift
//  Lecture 1 Calculator
//
//  Created by Konstantin Konstantinov on 4/14/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// Main calculator display
    @IBOutlet weak var display: UILabel!
    
    /// Display that shows history of operations
    @IBOutlet weak var operationsSequenceDisplay: UILabel!
    
    /// Display that shows M variable value
    @IBOutlet weak var mDisplay: UILabel!
    
    /// Calculator's model
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    /// Collection that stores M variable value
    private var mValue: Dictionary<String, Double>?
    
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
    private var displayValue: Double {
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
            if mathematicalSymbol == "M" {
                brain.setOperand(variable: "M")
                //brain.performOperation("=")
            } else {
                brain.performOperation(mathematicalSymbol)
            }
        }
        
        if let result = brain.evaluate(using: mValue).result {
            displayValue = result
        }
        
        if let description = brain.description {
            operationsSequenceDisplay.text = description + (brain.resultIsPending ? "…" : "=")
        } else {
            operationsSequenceDisplay.text = ""
        }
    }
    
    /// ->M button touch
    @IBAction func setMTouch(_ sender: UIButton) {
        mValue = ["M": displayValue]
        mDisplay.text = "M = " + String(displayValue)
        if let result = brain.evaluate(using: mValue).result {
            displayValue = result
        }
        userIsInTheMiddleOfTyping = false
    }
    
    /// Clear button touch implementation
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain.clearCalculator()
        userIsInTheMiddleOfTyping = false
        display.text = "0"
        operationsSequenceDisplay.text = ""
        mValue = nil
        mDisplay.text = "M = 0"
    }
    
}

