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
    
    var userIsInTheMiddleOfTyping = false
    
    var equalButtonPressed = false
    
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
            
            if equalButtonPressed {
                brain.description = ""
            }
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let mathematicalSymbol = sender.currentTitle {
            
            if mathematicalSymbol == "=" && userIsInTheMiddleOfTyping {
                equalButtonPressed = true
            } else {
                equalButtonPressed = false
            }
            
            switch mathematicalSymbol {
            case "=":
                if userIsInTheMiddleOfTyping {
                    brain.setOperand(displayValue)
                    userIsInTheMiddleOfTyping = false
                    brain.description += String(displayValue)
                }
            case "√":
                if userIsInTheMiddleOfTyping {
                    brain.setOperand(displayValue)
                    userIsInTheMiddleOfTyping = false
                }
                if !brain.resultIsPendingGet && brain.description != "" {
                    brain.description = "√(" + brain.description + ")"
                } else {
                    brain.description += "√" + String(displayValue)
                }
            case "C":
                userIsInTheMiddleOfTyping = false
                display.text = "0"
                sequenceOfOperations.text = ""
                
            default:
                if userIsInTheMiddleOfTyping {
                    brain.setOperand(displayValue)
                    userIsInTheMiddleOfTyping = false
                    brain.description += String(displayValue) + " " + mathematicalSymbol + " "
                } else {
                    brain.description += " " + mathematicalSymbol + " "
                }
            }
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if (brain.description != "") {
            sequenceOfOperations.text = brain.description + (brain.resultIsPendingGet ? "..." : "=")
        }
    }
    
    
}

