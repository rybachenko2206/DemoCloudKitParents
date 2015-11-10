//
//  AddChildViewController.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/5/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import UIKit

enum Gender: Int16 {
    case Male = 0
    case Female
    case Pervert
}


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
    @IBOutlet var addChildBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    
    //MARK: Properties
    var isAddChild: Bool!
    let startBirthdayDate: Double = -946771200 //01.01.1940
    

    //MARK: Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biographyTV.layer.cornerRadius = 8.0
        biographyTV.text = "Resume"
        professionTF.hidden = isAddChild
        
        biographyTV.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        professionTF.delegate = self
        birthdayTF.delegate = self
        setDatePickerToBirthdayTF()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    

    //MARK: Action functions
    
    @IBAction func addChildTapped(sender: AnyObject) {
        
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePerson(sender: AnyObject) {
        if !canCreateEntity() {
            showAlertView("", message: "Fill required text fuilds to create person", cancelButtonTitle: "OK")
            return;
        }
        
        if isAddChild == true {
            
        } else {
            let parent = CDParent.createInContext(CoreDataManager.sharedInstance.managedObjectContext) as CDParent
            parent.firstName = firstNameTF.text
            parent.lastName = lastNameTF.text
            parent.birthday = SharedDateFormatter.sharedInstance.dateFromString(birthdayTF.text!, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
            parent.profession = professionTF.text
            parent.gender = Int16.init(genderSegmentControl.selectedSegmentIndex)
            parent.notes = biographyTV.text
            
            let avatarImage: UIImage = (avatarImageView.image != nil ? avatarImageView.image : UIImage(named: "cht_emptyAvatar_image"))!
            
  
            let timestampDate: NSTimeInterval = NSDate().timeIntervalSince1970
            let imageName = String(timestampDate)
            parent.imageName = imageName
            
            ImageManager.sharedInstanse.saveImage(avatarImage, imageName: imageName)
            
            
            let alertView = UIAlertController(title: "Success", message: "New parent \(parent.firstName) \(parent.lastName)", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {( action: UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(alertView, animated: true, completion: nil)
        }
        CoreDataManager.sharedInstance.saveContext()
        
        
        
    }

    @IBAction func setGender(sender: AnyObject) {
    }
    
    @IBAction func avatarImageTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            self.view.endEditing(true)
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func birthdayValueChanged(sender: UIDatePicker) {
        birthdayTF.text = SharedDateFormatter.sharedInstance.stringFromDate(sender.date, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
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
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Private functions
    
    private func pathToDocumentsDirectory() -> NSString {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString as NSString
    }
    
    private func canCreateEntity () -> Bool {
        if firstNameTF.text?.isEmpty == true ||
            lastNameTF.text?.isEmpty == true ||
            birthdayTF.text?.isEmpty == true {
            return false
        }
        return true
    }
    
    private func setDatePickerToBirthdayTF () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.minimumDate = NSDate(timeIntervalSince1970: startBirthdayDate)
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: Selector("birthdayValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        birthdayTF.inputView = datePicker
    }
    
    private func showAlertView(title: String, message: String, cancelButtonTitle: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: {( action: UIAlertAction) -> Void in
            
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
}
