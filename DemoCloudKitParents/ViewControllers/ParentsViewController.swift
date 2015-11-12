//
//  ParentsViewController.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/5/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import UIKit
import CloudKit
import CoreData


protocol ParentsViewControllerDelegate {
    func didSelectPerson(person: CDParent)
}


class ParentsViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var allChildrenBarButtonItem: UIBarButtonItem!
    
    
    
    //MARK: Properties
    var parents: Array <CDParent>  = [CDParent]()
    var ignoreParent: CDParent?
    var delegate: ParentsViewControllerDelegate?
    
    
    //MARK: Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Parents"
        
        self.navigationItem.rightBarButtonItem = self.addBarButtonItem
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        parents = CoreDataManager.sharedInstance.fetchAllParents()
        if ignoreParent != nil && parents.count > 0 {
            if let index = parents.indexOf(ignoreParent!) {
                parents.removeAtIndex(index)
            }
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Action functions
    
    @IBAction func allChildrenTapped(sender: AnyObject) {
        let allChildrenVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChildrenListViewController") as! ChildrenListViewController
        allChildrenVC.children = CoreDataManager.sharedInstance.fetchAllChildtren()
        
        self.navigationController?.pushViewController(allChildrenVC, animated: true)
    }
    
    @IBAction func createParentTapped(sender: AnyObject) {
        let createParentVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddChildViewController") as! AddChildViewController
        createParentVC.isAddChild = false
        
        let navController = UINavigationController.init(rootViewController: createParentVC)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    

    // MARK: Delegate functions:
    
    // MARK: -UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ParentsCell.cellIdentifier(), forIndexPath: indexPath) as! ParentsCell
        
        let parent = parents[indexPath.row]
        cell.setParent(parent)

        return cell
    }
    
    
    // MARK: -UITableViewDelegate
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ParentsCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let parent = parents[indexPath.row]
        if self.modalPresentationStyle == UIModalPresentationStyle.Popover {
            self.delegate?.didSelectPerson(parent)
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        
        let showParentVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddChildViewController") as! AddChildViewController
        showParentVC.isAddChild = false
        showParentVC.parent = parent
        
        self.navigationController?.pushViewController(showParentVC, animated: true)
    }
    
    
}
