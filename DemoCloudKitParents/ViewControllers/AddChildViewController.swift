//
//  AddChildViewController.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/5/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import UIKit


class AddChildViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:  Outlets
    @IBOutlet weak var avatarImageView: RoundedImageView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var professionTF: UITextField!
    
    @IBOutlet weak var biographyTV: UITextView!
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    
    //MARK: Properties
    var isAddChild: Bool!
    var imageURL: NSURL?
    let tempImageName = "temp_image.jpg"
    

    //MARK: Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biographyTV.layer.cornerRadius = 8.0
        biographyTV.text = "Resume"
        professionTF.hidden = isAddChild
        
        biographyTV.delegate = self
        birthdayTF.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        professionTF.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    //MARK: Action functions
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePerson(sender: AnyObject) {
    }

    @IBAction func setGender(sender: AnyObject) {
    }
    
    @IBAction func avatarImageTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: Delegate functions:
    
    //MARK: -UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //MARK: -UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: -UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        avatarImageView.image = image
        if image != nil {
            saveImageLocally(image)
        } else {
            saveImageLocally(UIImage(named: "cht_emptyAvatar_image"))
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Private functions
    private func saveImageLocally(image: UIImage!) {
        let imageData: NSData = UIImageJPEGRepresentation(avatarImageView.image!, 0.8)!
        let pathToDocumentsDir: NSString =  pathToDocumentsDirectory()
        let path = pathToDocumentsDir.stringByAppendingPathComponent(tempImageName)
        
        imageURL = NSURL(fileURLWithPath: path)
        if imageURL != nil {
            if imageData.writeToURL(imageURL!, atomically: false) == false {
                print("---Error!! WriteToURL iamge == false")
            }
        }
        
    }
    
    private func pathToDocumentsDirectory() -> NSString {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString as NSString
    }
    
}
