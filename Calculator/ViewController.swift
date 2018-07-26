//
//  ViewController.swift
//  Calculator
//
//  Created by Travis Ryan on 7/23/18.
//  Copyright © 2018 Travis Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userInTheMiddleOfTyping = false
    var userHasEnteredDecimal = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        brain.handlePotentialDescriptionClear()
        let digit = sender.currentTitle!
        brain.description += digit+" "
        if !((digit==".") && (display.text!.range(of:".") != nil)) {
            if (userInTheMiddleOfTyping) {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                display!.text = digit
                userInTheMiddleOfTyping = true
            }
        }
        print(brain.getCompleteHistory())
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text! = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        brain.handlePotentialDescriptionClear()
        if sender.currentTitle == "C"{
            brain.clearBrain()
            display!.text = "0"
        } else{
            if userInTheMiddleOfTyping{
                brain.setOperand(displayValue)
                userInTheMiddleOfTyping = false
            }
            if let mathematicalSymbol = sender.currentTitle {
                brain.performOperation(mathematicalSymbol)
            }
            if let result = brain.result {
                displayValue = result
            }
        }
        print(brain.getCompleteHistory())
    }
    
    
}

