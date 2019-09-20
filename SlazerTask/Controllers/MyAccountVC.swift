//
//  MyAccountVC.swift
//  SlazerTask
//
//  Created by Prasad Ch on 28/08/19.
//  Copyright © 2019 Prasad Ch. All rights reserved.
//

import UIKit
import Alamofire

class MyAccountVC: UIViewController {

    @IBOutlet weak var profileBtnImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        profileBtnImage.layer.cornerRadius = profileBtnImage.frame.size.height / 2
        profileBtnImage.layer.masksToBounds = true
    }
    
    // MARK: - ViewController methods
    @IBAction func profileImageClicked(_ sender: Any) {
        let otherAlert = UIAlertController(title: "Choose your option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: myHandler)
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: myHandler)
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        // relate actions to controllers
        otherAlert.addAction(cameraAction)
        otherAlert.addAction(galleryAction)
        otherAlert.addAction(dismiss)
        
        present(otherAlert, animated: true, completion: nil)
    }
    
    // MARK: - Customized methods
    func myHandler(alert: UIAlertAction){
        print("You tapped: \(alert.title ?? "")")
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        switch alert.title {
            
        case "Camera":
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                picker.sourceType = .camera
                present(picker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Camera not available", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        case "Gallery":
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func callUploadProfileImage(image:UIImage){

        let paramValues = ["WTOKEN":Constants.MyAccountHeaders.wToken,
                           "WLOCATION":Constants.MyAccountHeaders.wLocation] as [String : String]
        
        uploadImageIntoServer(image: image, paramValues: paramValues) { (uploadStatus, error) in
            
            let alert = UIAlertController(title: uploadStatus ? "Success" : "Failure", message: uploadStatus ? "Profile Image Uploaded Successfully" : "Error in upload", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MyAccountVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileBtnImage.setImage(image, for: .normal)
        print("Image")
        
        callUploadProfileImage(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
