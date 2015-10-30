//
//  TipViewController.swift
//  TipCalc
//
//  Created by Dave Vo on 10/27/15.
//  Copyright © 2015 Dave Vo. All rights reserved.
//

import UIKit

let PERCENT_KEY = "defaultPercentageIndex"
let PRE_DATA_KEY = "prevUserInput"
let DATETIME_KEY = "lastUserInputSavedAt"
let PREFER_KEY = "userPreference"

class TipViewController: UIViewController, UITextFieldDelegate {
    let EPSILON = 1e-6 // To compare 2 floats, or doubles
    
    @IBOutlet weak var billLabel: UITextField!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var smileyImage: UIImageView!
    @IBOutlet weak var roundedTipLabel: UILabel!
    @IBOutlet weak var roundedTotalLabel: UILabel!
    
    @IBOutlet weak var numPeopleLabel: UILabel!
    @IBOutlet weak var amountPerLabel: UILabel!
    
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var equalLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var nPeopleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var isUsingDarkTheme = false
    let darkColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
    let lightColor = UIColor(red: 128/255, green: 1, blue: 128/255, alpha: 1)
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var tipPercentage = 0.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("viewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the keyboard for the Bill become NumberPad with decimal point
        billLabel.keyboardType = UIKeyboardType.DecimalPad
        billLabel.text = ""
        billLabel.becomeFirstResponder()
        billLabel.delegate = self
        
        // Load previous user input if timeDiff < 10min
        if let userInputDatetime = defaults.objectForKey(DATETIME_KEY) as! NSDate! {
            let elapsedTime = NSDate().timeIntervalSinceDate(userInputDatetime)
            if elapsedTime < 600 { // 10 min
                if let userInput = defaults.objectForKey(PRE_DATA_KEY) as! String! {
                    billLabel.text = userInput
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Load the default settings, and pervious data here
        
        // what happens for the 1st time use of this default value, when it has not been set?
        let percentageIndex =  defaults.integerForKey(PERCENT_KEY)
        tipSegment.selectedSegmentIndex = percentageIndex
        
        if let settingString = defaults.objectForKey(PREFER_KEY) as! String! {
            print(settingString)
            roundedTipLabel.hidden = settingString[settingString.startIndex] == "0"
            roundedTotalLabel.hidden = settingString[settingString.startIndex.advancedBy(1)] == "0"
            isUsingDarkTheme = settingString[settingString.startIndex.advancedBy(2)] == "1"
        } else {
            roundedTipLabel.hidden = true
            roundedTotalLabel.hidden = true
            isUsingDarkTheme = false
        }
        loadTheme(isUsingDarkTheme)
        
        // TODO: dont know why but it doesn't trigger valueChanged when set by code :(
        tipSegmentValueChanged(tipSegment)
        
        
        //print("viewWillAppear")
        //print(percentageIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss the keypad when touch outside the billLabel
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        // If there are multiple textField, can use this way to apply for all
        // view.endEditing(true)
        // super.touchesBegan(touches, withEvent: event)
        
        // If single textField then can use this way
        // if the billLabel is empty, no sense to dismiss the keypad?
        if billLabel.text != "" {
            billLabel.resignFirstResponder()
        }
    }
    
    func displayTips() {
        // First catch the billLabel is empty?
        // in case user change the TipPercentage while the billLabel is empty
        let billValue = billLabel.text == "" ? 0.0 :Double(billLabel.text!)!
        var tipValue = tipPercentage * billValue
        // Round tip number
        if roundedTipLabel.hidden == false {
            tipValue = tipValue - floor(tipValue) < EPSILON ? tipValue : floor(tipValue+1)
        }
        
        var totalBill = billValue + tipValue
        // Round total bill
        if roundedTotalLabel.hidden == false {
            totalBill = totalBill - floor(totalBill) < EPSILON ? totalBill :floor(totalBill+1)
        }
        
        
        // Format locale currency
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        //formatter.locale = NSLocale(localeIdentifier: "en_US")
        
        let people = Int(numPeopleLabel.text!)
        tipsLabel.text = formatter.stringFromNumber(tipValue)
        totalLabel.text = formatter.stringFromNumber(totalBill)
        amountPerLabel.text = formatter.stringFromNumber(totalBill / Double(people!))
    }
    
    func loadTheme(isDark: Bool) {
        let bgColor: UIColor!
        let textColor: UIColor!
        if isDark {
            bgColor = darkColor
            textColor = lightColor
        } else {
            bgColor = lightColor
            textColor = darkColor
        }
        
        self.view.backgroundColor = bgColor
        self.billLabel.backgroundColor = bgColor
        self.billLabel.textColor = textColor
        self.billLabel.tintColor = textColor
        self.tipSegment.tintColor = textColor
        
        self.plusLabel.textColor = textColor
        self.tipsLabel.textColor = textColor
        self.roundedTipLabel.textColor = textColor
        
        self.equalLabel.textColor = textColor
        self.totalLabel.textColor = textColor
        self.roundedTotalLabel.textColor = textColor
        
        self.numPeopleLabel.textColor = textColor
        self.nPeopleLabel.textColor = textColor
        self.upButton.backgroundColor = bgColor
        self.downButton.backgroundColor = bgColor
        
        if isDark {
            self.upButton.setImage(UIImage(named: "up-light"), forState: UIControlState.Normal)
            self.downButton.setImage(UIImage(named: "down-light"), forState: UIControlState.Normal)
        } else {
            self.upButton.setImage(UIImage(named: "up-green"), forState: UIControlState.Normal)
            self.downButton.setImage(UIImage(named: "down-green"), forState: UIControlState.Normal)
        }
        
        self.amountPerLabel.textColor = textColor
        self.amountLabel.textColor = textColor
        
    }
    
    // UITextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Now validate the input as the user typing
        //print("user typing..." + string)
        
        // If user enter . at the very beginning, add 0 to becomce 0.
        if textField.text == "" && string == "." {
            textField.text = "0"
            return true
        }
        
        // Should not have leading 0, unless 0.x
        if textField.text == "0" {
            if string == "." {
                return true
            } else {
                textField.text = ""
            }
        }
        
        // Should not have more than 1 '.'
        if (textField.text!.containsString(".")) {
            if string == "." {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func billValueChanged(sender: UITextField) {
        // Need to constantly save the userInput
        let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        defaults.setObject(currentDateTime, forKey: DATETIME_KEY)
        defaults.setObject(billLabel.text, forKey: PRE_DATA_KEY)
        
        defaults.synchronize()
        
        displayTips()
    }
    
    @IBAction func tipSegmentValueChanged(sender: UISegmentedControl) {
        switch tipSegment.selectedSegmentIndex {
        case 0:
            tipPercentage = 0.15
            smileyImage.image = isUsingDarkTheme ? UIImage(named: "justOK-light") :UIImage(named: "justOK-green")
        case 1:
            tipPercentage = 0.18
            smileyImage.image = isUsingDarkTheme ? UIImage(named: "good-light") :UIImage(named: "good-green")
        case 2:
            tipPercentage = 0.20
            smileyImage.image = isUsingDarkTheme ? UIImage(named: "excellent-light") : UIImage(named: "excellent-green")
        default: tipPercentage = 0.0  // This should never happen
        }
        displayTips()
    }
    
    @IBAction func increasePeople(sender: UIButton) {
        let n = Int(numPeopleLabel.text!)
        numPeopleLabel.text = "\(n!+1)"
        displayTips()
    }
    
    @IBAction func decreasePeople(sender: UIButton) {
        let n = Int(numPeopleLabel.text!)
        if n > 1 {
            numPeopleLabel.text = "\(n!-1)"
            displayTips()
        }
    }
}

