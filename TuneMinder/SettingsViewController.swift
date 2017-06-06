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

class SettingsViewController: UIViewController {
    let settings = UserDefaults.standard

    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let phoneNumber = settings.string(forKey: settingsKeys.phoneNumber) {
            print(phoneNumber) // Some String Value
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButton(_ sender: UIButton) {
        self.view.endEditing(true)
        settings.set(phoneTextField.text, forKey: settingsKeys.phoneNumber)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
