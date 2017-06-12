//
//  DetailViewController.swift
//  TuneMinder
//
//  Created by Omri Gazitt on 6/11/17.
//  Copyright © 2017 Omri Gazitt. All rights reserved.
//


import UIKit
import FirebaseStorage

class DetailViewController: UIViewController {

    var imagePath = ""
    var storageRef: StorageReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let settings = UserDefaults.standard

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        storageRef = Storage.storage().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/\(imagePath)"
        guard let fileURL = URL.init(string: filePath) else { return }
        
        // [START downloadimage]
        storageRef.child(imagePath).write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                //self.statusTextView.text = "Download Failed"
                return
            } else if let localPath = url?.path {
                //self.statusTextView.text = "Download Succeeded!"
                self.imageView.image = UIImage.init(contentsOfFile: localPath)
                print("got a URL: \(localPath)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
}
