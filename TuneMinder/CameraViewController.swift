//
//  CameraViewController.swift
//  TuneMinder
//
//  Created by Omri Gazitt on 5/31/17.
//  Copyright © 2017 Omri Gazitt. All rights reserved.
//

import UIKit
import Photos
import Firebase

class CameraViewController: UIViewController,
                            UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storageRef: StorageReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let settings = UserDefaults.standard
    var saving = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        storageRef = Storage.storage().reference()
        saving = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

        // [START storageauth]
        // Using Cloud Storage for Firebase requires the user be authenticated. Here we are using
        // anonymous authentication.
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously(completion: { (user: User?, error: Error?) in
                if let error = error {
                    //self.urlTextView.text = error.localizedDescription
                    //self.takePicButton.isEnabled = false
                } else {
                    //self.urlTextView.text = ""
                    //self.takePicButton.isEnabled = true
                }
            })
        }
        // [END storageauth]
    
        if self.saving {
            return
        }

        // MARK: - Image Picker
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        present(picker, animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                //let filePath = Auth.auth().currentUser!.uid +
                //"/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(imageFile!.lastPathComponent)"
                
                let phoneNumber = self.settings.string(forKey: settingsKeys.phoneNumber)
                let filePath = "\(phoneNumber ?? "14257650079").\(imageFile!.lastPathComponent).jpg"

                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"

                // [START uploadimage]
                self.storageRef.child(filePath)
                    .putFile(from: imageFile!, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Error uploading: \(error)")
                            //self.urlTextView.text = "Upload Failed"
                            return
                        }
                        self.uploadSuccess(metadata!, storagePath: filePath)
                }
                // [END uploadimage]
            })
        } else {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
            //let imagePath = Auth.auth().currentUser!.uid +
            //"/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            
            let phoneNumber = settings.string(forKey: settingsKeys.phoneNumber)
            let imagePath = "\(phoneNumber ?? "14257650079").\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef.child(imagePath).putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    //self.urlTextView.text = "Upload Failed"
                    return
                }
                self.uploadSuccess(metadata!, storagePath: imagePath)
            }
        }
        
        self.saving = true
    }
    
    func uploadSuccess(_ metadata: StorageMetadata, storagePath: String) {
        print("Upload Succeeded!")

        save(url: storagePath)
        saving = false

        // switch to the tags tab bar item
        self.tabBarController?.selectedIndex = 2;

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
        // switch to the tags tab bar item
        self.tabBarController?.selectedIndex = 2;
    }

    func save(url: String) {        
        let context = appDelegate.persistentContainer.viewContext
        let tag = Tag(context: context)
        tag.url = url
        appDelegate.saveContext()
    }
}

