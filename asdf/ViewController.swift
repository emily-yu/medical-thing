//
//  ViewController.swift
//  asdf
//
//  Created by Emily on 2/4/17.
//  Copyright © 2017 Emilyasdf. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagepickedtbh:UIImage!
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var color1 = hexStringToUIColor(hex: "#d9d9d9")
        self.view.backgroundColor = color1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func writeToFirebase(_ sender: Any) { //converts shit to base64
        //Use image name from bundle to create NSData
        let image : UIImage = UIImage(named:"favicon.png")!
        //Now use image to create into NSData format
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        
        let base64String = (imageData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(base64String) // super long shit base64
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("same")
        picker.dismiss(animated: true, completion: nil)
    }

    
    @IBOutlet var imageView: UIImageView!
    @IBAction func takePhoto(_ sender: UIButton) {
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        
//        present(imagePicker, animated: true, completion: nil)
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
//        }
        print("hey it's me");
        
    }
    
    //same gets image picked
    var imagePicker: UIImagePickerController!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //get image thing
        print("haeoijfaociweacmwiejcmaowiecmaowiec")
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.image = chosenImage
        print(chosenImage) //image
        imagepickedtbh = chosenImage
//        print(imagepickedtbh)
        
        //base64 thing
        //Use image name from bundle to create NSData
        //Now use image to create into NSData format
        let imageData: Data! = UIImageJPEGRepresentation(imagepickedtbh!, 0.1)
        
        let base64String = (imageData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        var ref = FIRDatabase.database().reference()
        var postRef = ref.child("base64string")
        ref.updateChildValues(["base64string": base64String])
//        postRef.observe(FIRDataEventType.value, with: { (snapshot) in //this gets the value at current pt
//            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//            if let unwrapped = snapshot.value {
////                print(unwrapped)
//                ref.updateChildValues(["base64string": unwrapped]) //this shit updates the thing
//                
//            }
//        })
        
        dismiss(animated: true, completion: nil)
    }
 

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil);
    }
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        print("aweoidjxawoeimejcd");
//                print("same")
//        imagePicker.dismiss(animated: true, completion: nil)
//        
//        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//            imagePicker.allowsEditing = false
    
//            print(info);
//            let image = info
//            imageView.image = image
//            self.navigationController?.present(imagePicker, animated: true, completion: nil);
    
//            self.present(imagePicker, animated: true, completion: nil)
            
//        }
//    }
    
    
    
    @IBAction func firebasetest(_ sender: Any) { //does nothing basically
//        var ref = FIRDatabase.database().reference()
//        var postRef = ref.child("base64string")
//        postRef.observe(FIRDataEventType.value, with: { (snapshot) in //this gets the value at current pt
//            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//            if let unwrapped = snapshot.value {
//                print(unwrapped)
//                ref.updateChildValues(["base64string": unwrapped]) //this shit updates the thing
//                
//            }
//        })
        
        
        //opens photo library
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
}
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        //Save image
//        let img = UIImage()
//        let data = UIImagePNGRepresentation(img)
////        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "myImageKey")
////        NSUserDefaults.standardUserDefaults().synchronize()
////        NSLog("Image stored?")
//        print("same")
//        viewDidLoad()
//        
    
    }

