//
//  RoundedImageView.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/6/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import UIKit
//import Cocoa

class RoundedImageView: UIImageView {

    override func awakeFromNib() {
         super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.layer.masksToBounds = true
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }
}
