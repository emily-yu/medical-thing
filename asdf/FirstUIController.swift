//
//  FirstUIController.swift
//  asdf
//
//  Created by Emily on 2/4/17.
//  Copyright © 2017 Emilyasdf. All rights reserved.
//
import UIKit
import Foundation

class FirstUIController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    
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
    @IBAction func choosePhoto(_ sender: UIButton) {
        print("same")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagepickedtbh = pickedImage
        }
        dismiss(animated: true, completion: nil)
        // segue it to the other thing lul
    }
}
