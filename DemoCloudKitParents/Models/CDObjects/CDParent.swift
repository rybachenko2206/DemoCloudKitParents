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

}
