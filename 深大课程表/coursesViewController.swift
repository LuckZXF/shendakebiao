//
//  coursesViewController.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/23.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

class coursesViewController : UIViewController , UISearchBarDelegate ,UITableViewDelegate,UITableViewDataSource, addcoursedelegate,UIAlertViewDelegate{
    
    @IBOutlet weak var sb: UISearchBar!
    
    @IBOutlet weak var tv: UITableView!
    var arrSearch = [String]()
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sb.delegate = self
        tv.delegate = self
        tv.dataSource = self
        let addButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertCell")
        self.navigationItem.rightBarButtonItem = addButton
      //  self.tabBarItem.image = UIImage(named: "tabbar2.png")
      //  self.tabBarItem.selectedImage = UIImage(named: "tabbar22.png")
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func insertCell() {
        let controller : addcourseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addcourse") as! addcourseViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        arrTitle.removeAtIndex(indexPath.row)
        arrDetail.removeAtIndex(indexPath.row)
        tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell : String = "cell"
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: Cell)
        let index = indexPath.row
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = arrTitle[index]
        cell.detailTextLabel?.text = arrDetail[index]
       // cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return arrSearch.count
        }
        else{
            return arrTitle.count
        }
    }
    
    func addCourse(controller: addcourseViewController, didFinishAddCourse course: courseobject) {
        //arrTitle.append(course.coursename!)
        //arrDetail.append(course.course_teachername!)
        arrTitle.insert(course.coursename!, atIndex: 0)
        arrDetail.insert(course.course_teachername!, atIndex: 0)
        let index = NSIndexPath(forRow: 0, inSection: 0)
        tv.insertRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.placeholder = "请输入您要查找的课程号"
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.placeholder = "搜索"
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = "搜索"
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        manager.requestSerializer = zxf
        manager.responseSerializer = fxz
        let params : Dictionary<String,String> = ["courseid" : searchBar.text!]
        manager.POST("http://www.shendakebiao.sinaapp.com/index.php/Home/Index/searchcourse", parameters: params, success: { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) in
            let responseDict = responseObject as! NSObject
            let coursearray = responseDict as! NSArray
            if coursearray.count == 0  {
                print("\(coursearray.count)")
                let view  = UIAlertView(title: "提示", message: "无此课程，您可自行创建", delegate: self, cancelButtonTitle: "ok")
                view.show()
            }
            else{
                courseArray = coursearray.copy() as! NSArray
                let controller : UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("text1") as! UINavigationController
                self.presentViewController(controller, animated: true, completion: nil)
            }
          //  print(responseDict)
               // let panduan = responseDict["result"] as! String
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                //Handle Error
                print(error)
                print(operation.responseString)
        })

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tv.deselectRowAtIndexPath(indexPath, animated: true)
        let coursename : String = arrTitle[indexPath.row]
        let courseteacher : String = arrDetail[indexPath.row]
        manager.requestSerializer = zxf
        manager.responseSerializer = fxz
        let params : Dictionary<String,String> = ["coursename" : coursename,"course_teachername" : courseteacher]
        manager.POST("http://www.shendakebiao.sinaapp.com/index.php/Home/Index/searchcourse1", parameters: params, success: { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) in
            let responseDict = responseObject as! NSObject
            let coursearray = responseDict as! NSArray
            if coursearray.count == 0  {
                print("\(coursearray.count)")
                let view  = UIAlertView(title: "提示", message: "无此课程，您可自行创建", delegate: self, cancelButtonTitle: "ok")
                view.show()
            }
            else{
                courseArray = coursearray.copy() as! NSArray
                let controller : UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("text1") as! UINavigationController
                self.presentViewController(controller, animated: true, completion: nil)
            }
            //  print(responseDict)
            // let panduan = responseDict["result"] as! String
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                //Handle Error
                print(error)
                print(operation.responseString)
        })

    }
    
}
