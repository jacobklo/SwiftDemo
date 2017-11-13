//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by j on 11/7/17.
//  Copyright © 2017 Jacob Lo. All rights reserved.
//

import Foundation

func multiply ( op1 : Double, op2 : Double ) -> Double {
  return op1 * op2
}

struct CalculatorBrain {
  
  private var m_Accumulator: Double?
  
  private enum Operation {
    case Constant(Double)
    case UnaryOperation( (Double) -> Double)
    case BinaryOperation ( (Double,Double) -> Double)
    case Equals
  }
  private var operations: Dictionary<String, Operation> = [
    "π" : Operation.Constant(Double.pi),
    "e" : Operation.Constant(M_E),
    "√" : Operation.UnaryOperation(sqrt),
    "cos" : Operation.UnaryOperation(cos),
    
    // there are 4 ways to pass a function,
    // 1) just pass the function
    "×" : Operation.BinaryOperation(multiply),
    // 2) use inline function ( Closure )
    "÷" : Operation.BinaryOperation({ ( op1 : Double, op2 : Double) -> Double in
      return op1 / op2;
    }),
    // 3) Swift actually already knows what this BinaryOperation is passing, so we can just don't write the type out in parameters
    "-" : Operation.BinaryOperation({ (op1, op2) in return op1 - op2 }),
    // 4) Even better, since it is in line function, Swift does not care what internal variable is, so just use $0, $1, $2,...
    "+" : Operation.BinaryOperation({ $0 + $1 }),
    
    "±" : Operation.UnaryOperation({ -$0 }),
    "=" : Operation.Equals
  ]
  
  mutating func performOperation ( _ mathSymbol : String ) {
    if let operation = operations[mathSymbol] {
      switch operation {
      case .Constant(let value):
        m_Accumulator = value
      case .UnaryOperation(let function):
        if m_Accumulator != nil {
          m_Accumulator = function(m_Accumulator!)
        }
      
      case .BinaryOperation ( let function ):
        if m_Accumulator != nil {
          pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: m_Accumulator! );
          m_Accumulator = nil
        }
      
      case .Equals:
        performPendinggBinaryOperation()
      }
    }
  
  }
  private mutating func performPendinggBinaryOperation() {
    if m_Accumulator != nil {
      m_Accumulator = pendingBinaryOperation?.perform(with: m_Accumulator! )
      pendingBinaryOperation = nil
    }
  }
  
  private var pendingBinaryOperation : PendingBinaryOperation?
  
  private struct PendingBinaryOperation {
    let function : ( Double, Double ) -> Double
    let firstOperand : Double
    
    func perform( with secondOperand : Double ) -> Double {
      return function ( firstOperand, secondOperand )
    }
  }
  
  mutating func setOperand ( _ operand : Double ) {
    m_Accumulator = operand
  }
  
  var result : Double? {
    get {
      return m_Accumulator
    }
  }
}
