//
//  SettingViewController.swift
//  TipCalc
//
//  Created by Dave Vo on 10/27/15.
//  Copyright © 2015 Dave Vo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var defaultPercentageSegment: UISegmentedControl!
    var defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var roundedTotalSwitch: UISwitch!
    @IBOutlet weak var roundedTipSwitch: UISwitch!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Set the defaultPercentageSegment to the default value
        defaultPercentageSegment.selectedSegmentIndex = defaults.integerForKey(PERCENT_KEY)
        
        if let settingString = defaults.objectForKey(PREFER_KEY) as! String! {
            roundedTipSwitch.on = settingString[settingString.startIndex] == "1"
            roundedTotalSwitch.on = settingString[settingString.startIndex.advancedBy(1)] == "1"
            themeSwitch.on = settingString[settingString.startIndex.advancedBy(2)] == "1"
        } else {
            roundedTotalSwitch.on = false
            roundedTipSwitch.on = false
            themeSwitch.on = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Return the selected value
    override func viewWillDisappear(animated: Bool) {
        
        defaults.setInteger(defaultPercentageSegment.selectedSegmentIndex, forKey: PERCENT_KEY)
        
        var settingString = ""
        var c: Character?
        // Save for Tip first, then total, then Theme
        c = roundedTipSwitch.on ? "1" : "0"
        settingString.append(c!)
        
        c = roundedTotalSwitch.on ? "1" : "0"
        settingString.append(c!)
        
        c = themeSwitch.on ? "1" : "0"
        settingString.append(c!)
        
        defaults.setObject(settingString, forKey: PREFER_KEY)
        
        defaults.synchronize()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
