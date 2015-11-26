//
//  MainController.swift
//  推送
//
//  Created by 赵希帆 on 15/9/16.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

protocol aaaaacontrollerDelegate {
    func goBack(string : String)
}

class MainController: UITableViewController , MainListControllerDelegate{
    
    var checklist:Checklist?
    var delegate1 : aaaaacontrollerDelegate?
    var dataModel : DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.checklist?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func ComeBack(sender: AnyObject) {
        dataModel?.setIndexOfSelectedChecklist(-1)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist!.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = checklist!.items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("maincell", forIndexPath: indexPath) 
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        configureCheckmarkForCell(cell, item: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = checklist!.items[indexPath.row]
        item.toggleChecked()
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        configureCheckmarkForCell(cell!, item: item)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate1?.goBack("ok")
      //  saveChecklistItems()
    }
    
    func configureCheckmarkForCell(cell:UITableViewCell,item:MainItem)
    {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        }
        else{
            label.text = ""
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist!.items.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
       // saveChecklistItems()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueStr = segue.identifier
        if segueStr == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MainListController
            controller.delegate = self
          //  controller.delegate1 = self
        }
        else if segueStr == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MainListController
            controller.delegate = self
            let indexPath = self.tableView.indexPathForCell(sender! as! UITableViewCell)
            controller.itemToEdit = checklist!.items[indexPath!.row]
        }
    }
    
    func addItemDidCancel(controller: MainListController) {
        controller.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItem(controller: MainListController, didFinishAddingItem item: MainItem) {
        let newRowIndex = checklist!.items.count
        checklist!.items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        controller.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
       // self.dismissViewControllerAnimated(true, completion: nil)
       // saveChecklistItems()
        delegate1?.goBack("ok")
    }
    
    func addItem(controller: MainListController,didFinishEditingItem item:MainItem)
    {
        self.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
      //  saveChecklistItems()
    }
    
    
}
