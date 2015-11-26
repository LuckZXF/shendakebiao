//
//  addcourseViewController.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/23.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

protocol addcoursedelegate {
     func addCourse(controller : addcourseViewController,didFinishAddCourse course : courseobject)
   // func addCoursefault(controller : addcourseViewController)
}

class addcourseViewController : UITableViewController , UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate{
    
    @IBOutlet weak var courseid: UITextField!
    @IBOutlet weak var coursename: UITextField!
    @IBOutlet weak var course_teachername: UITextField!
    @IBOutlet weak var stu_name: UITextField!
    @IBOutlet weak var stu_pingjia: UITextView!
    
    var delegate : addcoursedelegate?
    var addcourse : courseobject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let savebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "addcourseBtnPress")
        self.navigationItem.rightBarButtonItem = savebutton
        let backbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backbutton
        let msglabel : UILabel = UILabel(frame: CGRectMake(20, 15, 90,15))
        msglabel.textColor = UIColor.grayColor()
        msglabel.font = UIFont.systemFontOfSize(15)
        msglabel.text = "添加课程信息"
        self.view.addSubview(msglabel)
        stu_pingjia.delegate = self
        stu_pingjia.textColor = UIColor.grayColor()
        stu_pingjia.text = "请不要超过150个字"
        courseid.keyboardType = UIKeyboardType.NumberPad
        self.navigationItem.title = "添加课程评价"
        stu_name.text = stuname
        stu_name.userInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addcourseBtnPress(){
        let checkcourse : Dictionary<String,String> = ["courseid" : courseid.text!,"coursename" : coursename.text!]
        manager.requestSerializer = zxf
        manager.responseSerializer = fxz
        manager.POST("http://www.shendakebiao.sinaapp.com/index.php/Home/Index/checkcourseexist", parameters: checkcourse, success: { (operation : AFHTTPRequestOperation!, responseObject : AnyObject!)  in
            let responseDict = responseObject as! NSDictionary!
            let panduan = responseDict["result"] as! String
           // print(panduan)
            if panduan == "yes" {
                self.addcourseBtn()
            }
            else{
                let view = UIAlertView(title: "提示", message: "该门课已存在不需再次添加", delegate: self, cancelButtonTitle: "取消")
                view.show()
            }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                //Handle Error
                print(error)
                print(operation.responseString)
        })
    }
    
    func addcourseBtn(){
    
        addcourse = courseobject(courseid: courseid.text!, coursename: coursename.text! , course_teachername: course_teachername.text!, stu_name: stu_name.text!, stu_pingjia: stu_pingjia.text!)
        manager.requestSerializer = zxf
        manager.responseSerializer = fxz
        let params : Dictionary<String,String> = ["courseid" : courseid.text!,"coursename" : coursename.text!,"course_teachername" : course_teachername.text!,"stu_name" : stu_name.text!,"stu_pingjia" : stu_pingjia.text!]
        manager.POST("http://www.shendakebiao.sinaapp.com/index.php/Home/Index/create", parameters: params, success: { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) in
            self.delegate?.addCourse(self, didFinishAddCourse: self.addcourse)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                //Handle Error
                print(error)
                print(operation.responseString)
        })

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.becomeFirstResponder()
        stu_pingjia.textColor = UIColor.blackColor()
        stu_pingjia.text = ""
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            stu_pingjia.text = "请不要超过150字"
            stu_pingjia.textColor = UIColor.grayColor()
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
