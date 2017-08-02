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
    
    /// Action that reacts on digit button touch
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
            
            if equalOrBinaryOperationButtonIsPressed {
                brain.description = ""
            }
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
    
    /// Action that reacts on operation button touch
    @IBAction func performOperation(_ sender: UIButton) {
        if let mathematicalSymbol = sender.currentTitle {
            // Set 'equalOrBinaryOperationButtonIsPressed' for situation when user types new number without any operation
            if let currentOperationInModel = brain.operations[mathematicalSymbol] {
                switch currentOperationInModel {
                case .unaryOperation, .equal:
                    equalOrBinaryOperationButtonIsPressed = true
                default:
                    equalOrBinaryOperationButtonIsPressed = false
                }
            }
            
            switch mathematicalSymbol {
            case "=":
                if userIsInTheMiddleOfTyping {
                    brain.setOperand(displayValue)
                    userIsInTheMiddleOfTyping = false
                    brain.description += String(displayValue)
                }
            case "√", "cos", "x²", "x³":
                if userIsInTheMiddleOfTyping {
                    brain.setOperand(displayValue)
                    userIsInTheMiddleOfTyping = false
                }
                if !brain.resultIsPendingGet && brain.description != "" {
                    if mathematicalSymbol == "x²" {
                        brain.description = "(" + brain.description + ")²"
                    } else if mathematicalSymbol == "x³" {
                        brain.description = "(" + brain.description + ")³"
                    } else {
                        brain.description = mathematicalSymbol + "(" + brain.description + ")"
                    }
                } else {
                    if mathematicalSymbol == "x²" {
                        brain.description += String(displayValue) + "²"
                    } else if mathematicalSymbol == "x³" {
                        brain.description += String(displayValue) + "³"
                    } else if mathematicalSymbol == "cos" {
                        brain.description += mathematicalSymbol + "(" + String(displayValue) + ")"
                    } else {
                        brain.description += mathematicalSymbol + String(displayValue)
                    }
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
            
            if let result = brain.result {
                displayValue = result
            }
            if (brain.description != "") {
                sequenceOfOperations.text = brain.description + (brain.resultIsPendingGet ? "..." : "=")
            }
        }
    }
    
}

