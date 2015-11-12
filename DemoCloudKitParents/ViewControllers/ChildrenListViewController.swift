//
//  ChildrenListViewController.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/12/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class ChildrenListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var children: Array<CDChild> = [CDChild]()
    
    
    //MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        children = CoreDataManager.sharedInstance.fetchAllChildtren()
    }
    
    
    // MARK: Delegate functions:
    
    // MARK: -UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ChildrenCell.cellIdentifier(), forIndexPath: indexPath) as! ChildrenCell
        let child = children[indexPath.row]
        cell.setChild(child)
        
        return cell
    }
}
