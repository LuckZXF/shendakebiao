//
//  AllListViewController.swift
//  推送
//
//  Created by 赵希帆 on 15/9/17.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController , ListDetailViewControllerDelegate ,aaaaacontrollerDelegate, UINavigationControllerDelegate {
    
    
    var dataModel : DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(dataModel!.lists.count)")
       // dataModel?.loadChecklistItems()
      //  onCreateDate()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        let index = dataModel!.indexofSelectedChecklist()
        if index >= 0 && index < dataModel?.lists.count {
            let checklist = self.dataModel?.lists[index]
            self.performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel!.lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) 
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = dataModel!.lists[indexPath.row].name
        cell!.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        let list = dataModel!.lists[indexPath.row]
        let count = list.countUncheckedItems()
        if list.items.count == 0{
            cell!.detailTextLabel?.text = "还没有添加任务"
        }
        else{
            if count == 0{
                cell!.detailTextLabel?.text = "全部搞定"
            }
            else{
                cell!.detailTextLabel?.text = "还有\(count)个任务要完成"
            }
        }
       // cell?.imageView?.image = UIImage(named: "zxf.png")
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checklist = dataModel!.lists[indexPath.row]
        self.performSegueWithIdentifier("ShowChecklist", sender: checklist)
        dataModel!.setIndexOfSelectedChecklist(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel!.lists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        dataModel!.saveCheckLists()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            print("okok")
            let navigationcontrollrt = segue.destinationViewController as! UINavigationController
            let controller = navigationcontrollrt.topViewController as! MainController
         //   let index = self.tableView.indexPathForCell(sender as! UITableViewCell)
         //   controller.checklist = lists[index!.row]
            controller.checklist = sender as? Checklist
            controller.delegate1 = self
            controller.dataModel = dataModel
        }
        else if segue.identifier == "AddChecklist" {
            let navigationcontroller = segue.destinationViewController as! UINavigationController
            let controller = navigationcontroller.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controllrt : ListDetailViewController,didFinishAddingChecklist checklist : Checklist) {
        let newRowIndex = dataModel!.lists.count
        dataModel!.lists.append(checklist)
        dataModel!.sortCheckLists()
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        self.dismissViewControllerAnimated(true, completion: nil)
        dataModel!.saveCheckLists()
       // dataModel!.sortCheckLists()
    }
    
    func listDetailViewController(controllrt : ListDetailViewController,didFinishEditingChecklist checklist : Checklist) {
        self.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
        dataModel!.saveCheckLists()
        dataModel!.sortCheckLists()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel!.lists[indexPath.row]
        controller.checklistToEdit = checklist
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    func goBack(string: String) {
        print(string)
        dataModel!.saveCheckLists()
        
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == self {
            dataModel!.setIndexOfSelectedChecklist(-1)
        }
    }
    
}
