//
//  ChildrenCell.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/12/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import UIKit
import CoreData

class ChildrenCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var parentsLabel: UILabel!
    
    //MARK: Interface methods
    func setChild(child: CDChild) {
        setName(child.firstName!, lastName: child.lastName!)
        setYears(child.birthday!)
        setParents(child.parents)
        
        if let imgName = child.imageName {
            let fetchedImage = ImageManager.sharedInstanse.getImageWithName(imgName)
            if  fetchedImage != nil {
                avatarImageView.image = fetchedImage
            }
        }
        
    }
    
    // MARK: Class methods
    class func cellIdentifier() -> String {
        return String(ChildrenCell)
    }
    
    
    //MARK: Private functions
    private func setName(firstName: String, lastName: String) {
        let name = firstName + " " + lastName
        nameLabel.text = name
    }
    
    private func setYears(birthday: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year], fromDate: birthday)
        
        var years: Int = components.year
        
        let components2 = calendar.components([.Year], fromDate: NSDate())
        let currentYear = components2.year
        years = currentYear - years
        
        yearsLabel.text = "\(years) years"
    }
    
    private func setParents(parents: NSSet?) {
        if parents == nil || parents!.count == 0 {
            return
        }
        
        var pStr = ""
        
        for p in parents! {
            if let fName: String = p.firstName {
                pStr += fName + " "
            }
            if let lName: String = p.lastName {
                pStr += lName + "\n"
            }
        }
        
        parentsLabel.text = pStr
    }
}
