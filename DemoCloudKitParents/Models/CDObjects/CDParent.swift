//
//  CDParent.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/5/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import Foundation
import CoreData


class CDParent: NSManagedObject {

    internal class func createInContext (context: NSManagedObjectContext) -> CDParent {
        let entityDescr = NSEntityDescription.entityForName(String(CDParent), inManagedObjectContext: context)
        let newParent = CDParent.init(entity: entityDescr!, insertIntoManagedObjectContext: context)
        
        return newParent
    }
    
    
    // MARK: Interface functions
    
    func addChildObject(value: CDChild) {
        self.mutableSetValueForKey("children").addObject(value)
    }
    
    func getChidrenInfo () -> String {
        var childrenInfo: String = "Children:\n"
        
        //TODO: show children
        
        if  self.children?.count == 0 {
            childrenInfo = "childless"
        } else {
            for child in self.children! {
                if let firstN = child.firstName {
                    childrenInfo += " " + firstN! + " "
                }
                if let lastN = child.lastName {
                    childrenInfo += " " + lastN! + ",\n"
                }
                
//                let date = SharedDateFormatter.sharedInstance.stringFromDate(child.birthday, dateFormat: SharedDateFormatter.sharedInstance.birthdayUkraineDateFormat)
//                if let born =  {
//                    
//                }
            }
        }
        
        return childrenInfo
    }

}
