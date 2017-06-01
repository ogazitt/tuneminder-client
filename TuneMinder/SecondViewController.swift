//
//  SecondViewController.swift
//  TuneMinder
//
//  Created by Omri Gazitt on 5/31/17.
//  Copyright © 2017 Omri Gazitt. All rights reserved.
//

import UIKit
import FirebaseStorage

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let storage = Storage.storage()

        // Create a root reference
        let storageRef = storage.reference()

        // File located on disk
        let localFile = URL(string: "path/to/image")!
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

