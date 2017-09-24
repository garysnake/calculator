//
//  ViewController.swift
//  true calculator
//
//  Created by GaryZh on 7/30/17.
//  Copyright © 2017 GaryZh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // every variable need to be initialized, hence optional here; "?" also means "= nil"
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if(userIsInTheMiddleOfTyping){
            if(digit != "." || !textCurrentlyInDisplay.contains(".")){
                display.text = textCurrentlyInDisplay + digit
            }
            
        }else{
            display.text = (digit == ".") ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        // "if" it's crucial, assume title can be read as normal symbol, just like throwing error
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
        
    }
    
    
    
    
    
}

