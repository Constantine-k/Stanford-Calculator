//
//  CalculatorBrain.swift
//  Lecture 1 Calculator
//
//  Created by Konstantin Konstantinov on 4/14/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//
import Foundation

struct CalculatorBrain {
    
    /// Accumulates value in calculator
    private var accumulator: (Double, String)?
    
    /// All possible operations types
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equal
        case clear
    }
    
    /// List of all operations implementation
    let operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt, { "√(" + $0 + ")" }),
        "cos": Operation.unaryOperation(cos, { "cos(" + $0 + ")" }),
        "±": Operation.unaryOperation({ -$0 }, { "-(" + $0 + ")" }),
        "×": Operation.binaryOperation(*, { $0 + "×" + $1 }),
        "÷": Operation.binaryOperation(/, { $0 + "÷" + $1 }),
        "+": Operation.binaryOperation(+, { $0 + "+" + $1 }),
        "-": Operation.binaryOperation(-, { $0 + "-" + $1 }),
        "%": Operation.unaryOperation({ $0 * 0.01 }, { "(" + $0 + ")%" }),
        "x²": Operation.unaryOperation({ $0 * $0 }, { "(" + $0 + ")²" }),
        "x³": Operation.unaryOperation({ $0 * $0 * $0 }, { "(" + $0 + ")³" }),
        "xʸ": Operation.binaryOperation(pow, { $0 + "^" + $1 }),
        "=": Operation.equal,
        "C": Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (value, symbol)
            case .unaryOperation(let function, let description):
                if accumulator != nil {
                    accumulator = (function(accumulator!.0), description(accumulator!.1))
                }
            case .binaryOperation(let function, let description):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator!, function: function, description: description)
                    accumulator = nil
                }
            case .equal:
                if pendingBinaryOperation != nil && accumulator != nil {
                    accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                    pendingBinaryOperation = nil
                }
            case .clear:
                accumulator = nil
                pendingBinaryOperation = nil
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let firstOperand: (Double, String)
        let function: (Double, Double) -> Double
        let description: (String, String) -> String
        
        func perform(with secondOperand: (Double, String)) -> (Double, String) {
            return (function(firstOperand.0, secondOperand.0), description(firstOperand.1, secondOperand.1))
        }
    }
    
    /// Sets operand value
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, String(operand))
    }
    
    /// Returns result
    var result: Double? {
        if nil != accumulator {
            return accumulator!.0
        }
        return nil
    }
    
    /// Informs while operation result is pending
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    
    /// A text that shows operations history
    var description: String? {
        if resultIsPending {
            return pendingBinaryOperation!.description(pendingBinaryOperation!.firstOperand.1, accumulator?.1 ?? "")
        } else {
            return accumulator?.1
        }
    }
}
