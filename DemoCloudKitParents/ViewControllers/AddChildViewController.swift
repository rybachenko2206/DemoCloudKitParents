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


class AddChildViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, ParentsViewControllerDelegate {
    
    //MARK:  Outlets
    @IBOutlet weak var avatarImageView: RoundedImageView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var professionTF: UITextField!
    
    @IBOutlet weak var marriedTF: UITextField!
    @IBOutlet weak var biographyTV: UITextView!
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var addChildBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    
    //MARK: Properties
    var isAddChild: Bool!
    var parent: CDParent?
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
        marriedTF.delegate = self
        birthdayTF.delegate = self
        setDatePickerToBirthdayTF()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isModal() == true {
            self.navigationItem.leftBarButtonItem = closeBarButtonItem
        }
        
        if isAddChild == true {
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
            
            marriedTF.hidden = true
            self.title = "Add child"
            biographyTV.hidden = true
        } else {
            self.navigationItem.rightBarButtonItems = [saveBarButtonItem, addChildBarButtonItem]
        }
        
        if parent != nil && !isAddChild {
            showParentData()
            biographyTV.text = parent!.getChidrenInfo()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    

    //MARK: Action functions
    
    @IBAction func addChildTapped(sender: AnyObject) {
        if !canCreateEntity() {
            showAlertView("", message: "Fill required text fuilds to create person", cancelButtonTitle: "OK")
            return
        }
        
        let createChildVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddChildViewController") as! AddChildViewController
        createChildVC.isAddChild = true
        createChildVC.parent = parent
        
        let navController = UINavigationController.init(rootViewController: createChildVC)
        self.presentViewController(navController, animated: true, completion: nil)
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
            createChild()
            
        } else {
            createParent()
        }
        
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
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 4 {
            showParentsListPopover()
            return false
        }
        
        return true
    }
    
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
    
    // MARK: -UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    //MARK: -ParentsViewControllerDelegate
    
    func didSelectPerson(person: CDParent) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        let gender: Int16 = parent != nil ?  parent!.gender : Int16(genderSegmentControl.selectedSegmentIndex)
        
        if person.gender == gender {
            
            dispatch_after(delayTime, dispatch_get_main_queue(), {() -> Void in
                self.showAlertView("Схаменись, не плоди збоченців!!!", message: "Цей Апп не схвалює одностатеві шлюби, так що будеш сам(а), раз так.", cancelButtonTitle: "Cancel")
            })
            
            return
        }
        
        if person.pair != nil {
            dispatch_after(delayTime, dispatch_get_main_queue(), {() -> Void in
                self.showAlertView("This person have already married", message: "Choose anyone which isn't married yet ))", cancelButtonTitle: "Cancel")
            })
            return
        }
        
        let compoundText = "Married with " + person.firstName! + " " + person.lastName!
        marriedTF.text = compoundText
        parent?.pair = person
        CoreDataManager.sharedInstance.saveContext()
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
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func createParent() {
        parent = CDParent.createInContext(CoreDataManager.sharedInstance.managedObjectContext) as CDParent
        parent!.firstName = firstNameTF.text
        parent!.lastName = lastNameTF.text
        parent!.birthday = SharedDateFormatter.sharedInstance.dateFromString(birthdayTF.text!, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
        parent!.profession = professionTF.text
        parent!.gender = Int16.init(genderSegmentControl.selectedSegmentIndex)
        parent!.notes = biographyTV.text
        
        let avatarImage: UIImage = (avatarImageView.image != nil ? avatarImageView.image : UIImage(named: "cht_emptyAvatar_image"))!
        let timestampDate: NSTimeInterval = NSDate().timeIntervalSince1970
        let imageName = String(timestampDate)
        parent!.imageName = imageName
        
        ImageManager.sharedInstanse.saveImage(avatarImage, imageName: imageName)
        
        CoreDataManager.sharedInstance.saveContext()
        
        let message = "New parent " + self.parent!.firstName! + " " + self.parent!.lastName! + " was created"
        
        let alertView = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {( action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func createChild() {
        let newChild = CDChild.createInContext(CoreDataManager.sharedInstance.managedObjectContext) as CDChild
        newChild.firstName = firstNameTF.text
        newChild.lastName = lastNameTF.text
        newChild.birthday = SharedDateFormatter.sharedInstance.dateFromString(birthdayTF.text!, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
        newChild.gender = Int16.init(genderSegmentControl.selectedSegmentIndex)
        if parent != nil {
            newChild.addParentObject(parent!)
            if let pair = parent!.pair {
                newChild.addParentObject(pair)
            }
        }
        
        let avatarImage: UIImage = (avatarImageView.image != nil ? avatarImageView.image : UIImage(named: "cht_emptyAvatar_image"))!
        let timestampDate: NSTimeInterval = NSDate().timeIntervalSince1970
        let imageName = String(timestampDate)
        newChild.imageName = imageName
        ImageManager.sharedInstanse.saveImage(avatarImage, imageName: imageName)

        
        CoreDataManager.sharedInstance.saveContext()
        
        let message = "New kid " + newChild.firstName! + " " + newChild.lastName! + " was created"
        
        let alertView = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {( action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func isModal() -> Bool {
        if((self.presentingViewController) != nil) {
            return true
        }
        
        if(self.presentingViewController?.presentedViewController == self) {
            return true
        }
        
        if(self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) {
            return true
        }
        
        if((self.tabBarController?.presentingViewController?.isKindOfClass(UITabBarController)) != nil) {
            return true
        }
        
        return false
    }
    
    private func showParentData() {
        if parent == nil {
            return
        }
        
        avatarImageView.image = ImageManager.sharedInstanse.getImageWithName(parent!.imageName!)
        firstNameTF.text = parent?.firstName
        lastNameTF.text = parent?.lastName
        professionTF.text = parent?.profession
        genderSegmentControl.selectedSegmentIndex = Int((parent?.gender)!)
        birthdayTF.text = SharedDateFormatter.sharedInstance.stringFromDate((parent?.birthday)!, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
        
        biographyTV.text = parent!.getChidrenInfo()
        
        if let pair = parent?.pair {
            marriedTF.text = "Married with \(pair.firstName!) \(pair.lastName!)"
        } else {
            marriedTF.text = "Not merried"
        }
    }

    private func showParentsListPopover() {
        if CoreDataManager.sharedInstance.fetchAllParents().count == 0 {
            return
        }
        
        let parentsVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParentsViewController") as! ParentsViewController
        parentsVC.delegate = self
        parentsVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        parentsVC.ignoreParent = parent
        let popover: UIPopoverPresentationController = parentsVC.popoverPresentationController!
        popover.sourceView = marriedTF
        popover.delegate = self
        presentViewController(parentsVC, animated: true, completion:nil)
    }
    
}
