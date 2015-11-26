//
//  coursepingjiaViewController.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/24.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

class coursepingjiaViewController : UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource ,UITextViewDelegate{
    
    @IBOutlet weak var keyBoard: UIView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tv: UITableView!
    
  //  var coursearray : NSArray? = NSArray()
    
    var studentname : [String] = [String]()
    var studentpingjia : [String] = [String]()
    var course_id : String!
    var course_name : String!
    var course_teacher : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self
        textField.delegate = self
        let leftbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "goback")
        navigationItem.leftBarButtonItem = leftbutton
        textField.placeholder = "输入消息内容"
        textField.returnKeyType = UIReturnKeyType.Send
        textField.enablesReturnKeyAutomatically  = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        getCourseArray()
        course_id = courseArray[0]["courseid"] as! String
        course_name = courseArray[0]["coursename"] as! String
        course_teacher = courseArray[0]["course_teachername"] as! String
        self.navigationItem.title = course_name
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getCourseArray(){
        for i in courseArray {
            studentname.append(i["stu_name"] as! String)
            studentpingjia.append(i["stu_pingjia"] as! String)
        }
    }
    
    func goback(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentname.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell")
      //  cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
      //cell.textLabel?.text = "我爱你"
      //cell.selectionStyle = .None
        let index = indexPath.row
        var stulabel : UILabel = cell.viewWithTag(1) as! UILabel
        var stupingjiatextView : UITextView = cell.viewWithTag(2) as! UITextView
        stulabel.text = studentname[index]
        stupingjiatextView.text = studentpingjia[index]
        stupingjiatextView.delegate = self
        return cell
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tv.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func keyBoardWillShow(note:NSNotification)
    {
        
        tv.hidden = true
        let userInfo  = note.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
        
        var keyBaoardViewFrame = keyBoard.frame
        var deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            
            self.keyBoard.transform = CGAffineTransformMakeTranslation(0,-deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        tv.hidden = false
        tv.reloadData()
        let userInfo  = note.userInfo as! NSDictionary
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            
            self.keyBoard.transform = CGAffineTransformIdentity
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
        
        
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
        
        if sender.locationInView(self.view).y < self.view.bounds.height - 250{
            textField.resignFirstResponder()
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let pingjia : String = textField.text!
        manager.requestSerializer = zxf
        manager.responseSerializer = fxz
        let params : Dictionary<String,String> = ["courseid" : course_id,"coursename" : course_name,"course_teachername" : course_teacher,"stu_name" : stuname,"stu_pingjia" : textField.text!]
        manager.POST("http://www.shendakebiao.sinaapp.com/index.php/Home/Index/create", parameters: params, success: { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) in
            textField.resignFirstResponder()
            self.studentname.insert(stuname, atIndex: 0)
            self.studentpingjia.insert(pingjia, atIndex: 0)
            let index = NSIndexPath(forRow: 0, inSection: 0)
            self.tv.insertRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                //Handle Error
                print(error)
                print(operation.responseString)
        })
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.text = ""
    }
    
}

