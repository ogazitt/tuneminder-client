//
//  SettingsViewController.swift
//  TuneMinder
//
//  Created by Omri Gazitt on 6/4/17.
//  Copyright © 2017 Omri Gazitt. All rights reserved.
//

import UIKit

struct settingsKeys {
    static let phoneNumber = "phoneNumber"
    static let email = "email"
}

class SettingsViewController: UIViewController, UITextFieldDelegate {
    let settings = UserDefaults.standard

    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        phoneTextField.delegate = self;

        if let phoneNumber = settings.string(forKey: settingsKeys.phoneNumber) {
            phoneTextField.text = phoneNumber
        }
        
        phoneTextField.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButton(_ sender: UIButton) {
        self.view.endEditing(true)
        settings.set(phoneTextField.text, forKey: settingsKeys.phoneNumber)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        phoneTextField.resignFirstResponder()
        return true
    }
    
    /*
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
     */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
