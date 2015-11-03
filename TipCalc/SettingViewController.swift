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
    if let userPreferences = defaults.dictionaryForKey(userPreferKey) {
      defaultPercentageSegment.selectedSegmentIndex = userPreferences[percentageKey] as! Int!
      roundedTipSwitch.on = userPreferences[isRoundedTipKey] as! Bool!
      roundedTotalSwitch.on = userPreferences[isRoundedTotalKey] as! Bool!
      themeSwitch.on = userPreferences[isDarkKey] as! Bool!
    } else {
      defaultPercentageSegment.selectedSegmentIndex = 0
      roundedTipSwitch.on = false
      roundedTotalSwitch.on = false
      themeSwitch.on = false
    }
  }
  
  // Save the selected values
  override func viewWillDisappear(animated: Bool) {
    let userPreferences: [String : AnyObject] = [
      percentageKey: defaultPercentageSegment.selectedSegmentIndex,
      isRoundedTipKey: roundedTipSwitch.on,
      isRoundedTotalKey: roundedTotalSwitch.on,
      isDarkKey: themeSwitch.on
    ]
    defaults.setObject(userPreferences, forKey: userPreferKey)
    defaults.synchronize()
  }
  
}
