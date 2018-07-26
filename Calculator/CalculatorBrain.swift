//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Travis Ryan on 7/24/18.
//  Copyright © 2018 Travis Ryan. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var description = ""
    private var resultIsPending = false
    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var readyToClearDescription = false

    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clearBrain
    }
    
    private struct PendingBinaryOperation {
        let function : (Double, Double) -> Double
        let firstOperand : Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations : Dictionary<String,Operation> =
        ["π" : Operation.constant(Double.pi),
         "e" : Operation.constant(M_E),
         "√" : Operation.unaryOperation(sqrt),
         "cos" : Operation.unaryOperation(cos),
         "sin" : Operation.unaryOperation(sin),
         "tan" : Operation.unaryOperation(tan),
         "±" : Operation.unaryOperation({-$0}),
         "%" : Operation.unaryOperation({$0/100}),
         "x²" : Operation.unaryOperation({$0*$0}),
         "x³" : Operation.unaryOperation({$0*$0*$0}),
         "10ˣ" : Operation.unaryOperation({pow(10, $0)}),
         "×" : Operation.binaryOperation({$0*$1}),
         "÷" : Operation.binaryOperation({$0/$1}),
         "-" : Operation.binaryOperation({$0-$1}),
         "+" : Operation.binaryOperation({$0+$1}),
         "=" : Operation.equals,
         "C" : Operation.clearBrain]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String){
        description+=symbol+" "
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
                        pendingBinaryOperation = PendingBinaryOperation(function:function, firstOperand:accumulator!)
                        accumulator = nil
                        resultIsPending = true
                    }
                case .equals:
                    performPendingBinaryOperation()
                case .clearBrain:
                    clearBrain()
            }
        } else {
            print("Not a valid operation!")
        }
    }
    
    mutating func clearBrain(){
        accumulator = nil
        pendingBinaryOperation = nil
        description = ""
        resultIsPending = false
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            resultIsPending = false
            readyToClearDescription = true
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    mutating func handlePotentialDescriptionClear(){
        if(readyToClearDescription){
            description=""
        }
        readyToClearDescription = false
    }
    
    func getCompleteHistory()->String{
        var completeHistory = description
        if(resultIsPending){
            completeHistory+="..."
        }
        return completeHistory
    }
}
