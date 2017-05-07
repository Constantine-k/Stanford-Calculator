//
//  CalculatorBrain.swift
//  Lecture 1 Calculator
//
//  Created by Konstantin Konstantinov on 4/14/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equal
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        "x²": Operation.unaryOperation({ $0 * $0 }),
        "x³": Operation.unaryOperation({ $0 * $0 * $0 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "xʸ": Operation.binaryOperation({ pow($0, $1) }),
        "=": Operation.equal,
        "C": Operation.clear
    ]
    
    private var resultIsPending = false
    
    var description = ""
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator!, function: function)
                    accumulator = nil
                    resultIsPending = true
                }
            case .equal:
                if pendingBinaryOperation != nil && accumulator != nil {
                    accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                    pendingBinaryOperation = nil
                    resultIsPending = false
                }
            case .clear:
                accumulator = nil
                pendingBinaryOperation = nil
                resultIsPending = false
                description = ""
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let firstOperand: Double
        let function: (Double, Double) -> Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPendingGet: Bool {
        get {
            return resultIsPending
        }
    }
}

