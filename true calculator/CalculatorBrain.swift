//
//  CalculatorBrain.swift
//  true calculator
//
//  Created by GaryZh on 8/5/17.
//  Copyright © 2017 GaryZh. All rights reserved.
//

import Foundation


// function can be variable, below is explicit function syntax, concise syntax 
func changeSign(operand: Double) -> Double {
    return -operand
}
func multiply(opt1: Double, opt2: Double) -> Double{
    return opt1 * opt2
}


// classes have inheritance, struct do not
// classes live in the heap, but struct do not live in the heap, pass in copy (it will be efficient dont worry)
struct CalculatorBrain {
    
    // struct will initialize all var (but we still put ? as not set)
    private var accumulator: Double?
    
    // for more diversed cases
    private enum Operation {
        // associated value
        case constant(Double)
        // *function is just a type
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    // table, better than switch/case inserted below
    // better for adding future cases
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "log" : Operation.unaryOperation(log),
        "x²" : Operation.unaryOperation({ $0 * $0 }),
        // table of brevity "closure"
        "±" : Operation.unaryOperation({ (operand) in return -operand}),
        "×" : Operation.binaryOperation({ (opt1, opt2) in  opt1 * opt2 }),
        "/" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        
        "=" : Operation.equals
    ]
    
    
    
    mutating func performOperation(_ symbol: String){
        // add "if let ** = optional{}" for optionals
        if let operation = operations[symbol] {
            switch operation {
            case.constant(let value):
                accumulator = value
            case.unaryOperation(let function):
                // different but a check for optional
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil //IT IS to prevent the displayValue in the controller to be shown
                }
            case.equals:
                performPendingBinaryOperation()
                
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    mutating private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // mutating only exist in struct, for the purpose of send-copy mechanism
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
}
