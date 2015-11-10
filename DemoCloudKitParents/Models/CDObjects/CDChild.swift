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

}
