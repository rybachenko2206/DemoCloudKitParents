//
//  CDChild.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/5/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import Foundation
import CoreData


class CDChild: NSManagedObject {

    internal class func createInContext (context: NSManagedObjectContext) -> CDChild {
        let entityDescr = NSEntityDescription.entityForName(String(CDChild), inManagedObjectContext: context)
        let newChild = CDChild.init(entity: entityDescr!, insertIntoManagedObjectContext: context)
        
        return newChild
    }
    
    
    // MARK: Interface functions
    
    func addParentObject(value: CDParent) {
        self.mutableSetValueForKey("parents").addObject(value)
    }
    
    func getParentsInfo() -> String {
        var parentsInfoStr: String = "Parents:\n"
        
        if self.parents?.count == 0 {
            parentsInfoStr = "Orphan"
        } else {
            for parent in self.parents! {
                parentsInfoStr = parentsInfoStr + "\(parent.firstName!) \(parent.lastName!)\n"
            }
        }
        
        return parentsInfoStr
    }
    
    
}

