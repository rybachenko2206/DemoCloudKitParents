//
//  ParentsCell.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/10/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

class ParentsCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var avatarImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var childrenCountLabel: UILabel!
    

    // MARK: Interface functions
    
    func setParent(parent: CDParent) {
        setName(parent.firstName!, lastName: parent.lastName!)
        setBirthday(parent.birthday!)
        setCountChildren(parent.children!)
        
        let fetchedImage = ImageManager.sharedInstanse.getImageWithName(parent.imageName!)
        if  fetchedImage == nil {
            return
        }
        avatarImageView.image = fetchedImage
    }
    
    
    // MARK: Class functions
    
    class func cellIdentifier() -> String {
        return String(ParentsCell)
    }
    
    class func cellHeight() -> CGFloat {
        return 80
    }
    
    
    //MARK: Private functions
    
    private func setName(firstName: String, lastName: String) {
        let name = firstName + " " + lastName
        nameLabel.text = name
    }
    
    private func setBirthday(birthday: NSDate) {
        birthdayLabel.text = "Birthday: " + SharedDateFormatter.sharedInstance.stringFromDate(birthday, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
    }
    
    private func setCountChildren(childrens: NSSet?) {
        if  childrens == nil {
            return
        }
        let count: Int = childrens!.count
        
        var countStr = ""
        if count == 0 {
            countStr = "childless"
        } else if count == 1 {
            countStr = "1 child"
        } else {
            countStr = "\(count) children"
        }
        
        childrenCountLabel.text = countStr
    }
}
