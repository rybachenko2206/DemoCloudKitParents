//
//  SharedDateFormatter.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/9/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

class SharedDateFormatter: NSDateFormatter {
    static let sharedInstance = SharedDateFormatter()
    
    let birthdayUkraineDateFormat = "dd.MM.yyyy"
    
    func dateFromString(dateString: String, dateFormat: String) -> NSDate? {
        SharedDateFormatter.sharedInstance.dateFormat = dateFormat
        let date = SharedDateFormatter.sharedInstance.dateFromString(dateString)
        return date
    }
    
    func stringFromDate(date: NSDate, dateFormat: String) -> String {
        SharedDateFormatter.sharedInstance.dateFormat = dateFormat
        return SharedDateFormatter.sharedInstance.stringFromDate(date)
    }
}
