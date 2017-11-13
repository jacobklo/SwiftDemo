//
//  ViewController.swift
//  Calculator
//
//  Created by j on 11/6/17.
//  Copyright © 2017 Jacob Lo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var m_UserIsTyping : Bool = false
  
  @IBOutlet weak var m_Display: UILabel!

  @IBAction func touchDigit(_ sender: UIButton) {
    let digit : String = sender.currentTitle!
    let currentDisplayText = m_Display.text!
    if m_UserIsTyping {
      m_Display.text = currentDisplayText + digit
    }
    else {
      m_Display.text = digit
      m_UserIsTyping = true
    }
  }
  
  var displayValue : Double {
    get {
      if let currentValue = Double(m_Display.text!) {
        return currentValue
      }
      return 0
    }
    set {
      m_Display.text = String(newValue);
    }
  }
  
  private var brain = CalculatorBrain()
  
  @IBAction func performOperation(_ sender: UIButton) {
    
    if m_UserIsTyping {
      brain.setOperand(displayValue);
      m_UserIsTyping = false;
    }
    if let currentMathSymbol = sender.currentTitle {
      brain.performOperation(currentMathSymbol);
    }
    if let result : Double = brain.result {
      displayValue = result
    }
  }
}

