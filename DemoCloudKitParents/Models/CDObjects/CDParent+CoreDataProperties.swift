//
//  CDParent+CoreDataProperties.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/5/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDParent {

    @NSManaged var profession: String?
    @NSManaged var children: NSSet?
    @NSManaged var pair: CDParent?
    
    @NSManaged var birthday: NSDate?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var gender: Int16
    @NSManaged var notes: String?
    @NSManaged var imageName: String?

}
