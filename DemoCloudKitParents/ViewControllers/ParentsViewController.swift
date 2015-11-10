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


class ParentsViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    var parents: Array <CDParent>  = [CDParent]()
    
    
    //MARK: Properties
//    var parents
    
    
    //MARK: Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Parents"
        
        self.navigationItem.rightBarButtonItem = self.addBarButtonItem
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        parents = CoreDataManager.sharedInstance.fetchAllParents()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Action functions
    
    @IBAction func createParentTapped(sender: AnyObject) {
        let createParentVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddChildViewController") as! AddChildViewController
        createParentVC.isAddChild = false
        self.presentViewController(createParentVC, animated: true, completion: nil)
    }
    
    

    // MARK: Delegated functions:
    
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
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ParentsCell.cellHeight()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
