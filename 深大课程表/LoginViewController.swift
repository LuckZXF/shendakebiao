//
//  LoginViewController.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/18.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

//屏幕高和宽
let kwidth : CGFloat! = UIScreen.mainScreen().bounds.width
let kheight : CGFloat! = UIScreen.mainScreen().bounds.height

class loginViewController : UIViewController , UITextFieldDelegate {
  
    //登陆页面宽
//    let LGFrameWidth : CGFloat?
    
    //登陆页面高
 //   let LGFrameHeight : CGFloat?
    
    

 //   required init?(coder aDecoder: NSCoder) {
   //     fatalError("init(coder:) has not been implemented")
    //}

    let image : UIImage? = UIImage(named: "login.jpg")
    
    var nametextfield : UITextField = UITextField()
    
    var passwordfield : UITextField = UITextField()
    
    var deformationBtn : DeformationButton = DeformationButton(frame: CGRect(), color: UIColor.whiteColor())
    
    var personmsgdata : PersonmsgData = PersonmsgData()
    
    var personmsgitem : Personmsgitem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView : UIImageView! = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        imageView.image = image
        self.view.addSubview(imageView)
        var personimage : UIImage?
        let fullPath = dataFilePath()
        personimage = UIImage(contentsOfFile: fullPath as String)
        if personimage == nil {
            personimage = UIImage(named: "my.png")
        }
      //  personimage = UIImage(named: "my.png")
        //print("\(self.view.frame.width)  \(self.view.bounds.width)")
        let personImageView : UIImageView! = UIImageView(frame: CGRectMake(self.view.frame.width/2 - 70, self.view.frame.height / 4 - 20, self.view.bounds.width / 2 - 50  ,  self.view.frame.height / 4 - 30))
        personImageView.image = personimage
        personImageView.layer.masksToBounds = true
        personImageView.layer.cornerRadius = 70
        personImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        personImageView.layer.borderWidth = 0.5
        self.view.addSubview(personImageView)
        let namelabelsize : CGFloat! = 20.0
        let passwordsize : CGFloat! = 20.0
        let namelabel : UILabel = UILabel(frame: CGRectMake(self.view.frame.width/6,self.view.frame.height/2  ,namelabelsize * 2, namelabelsize))
        namelabel.backgroundColor = UIColor.clearColor()
        namelabel.textAlignment =  NSTextAlignment.Left
        namelabel.text = "姓名"
        namelabel.font = UIFont.systemFontOfSize(namelabelsize)
        namelabel.textColor = UIColor.redColor()
        self.view.addSubview(namelabel)
        let passwordlabel : UILabel = UILabel(frame: CGRectMake(self.view.frame.width / 6 , self.view.frame.height / 2 + namelabelsize * 3 , passwordsize * 2 ,passwordsize))
        passwordlabel.backgroundColor = UIColor.clearColor()
        passwordlabel.textAlignment = NSTextAlignment.Left
        passwordlabel.font = UIFont.systemFontOfSize(passwordsize)
        passwordlabel.text = "学号"
        passwordlabel.textColor = UIColor.redColor()
        self.view.addSubview(passwordlabel)
        nametextfield = UITextField(frame: CGRectMake(self.view.frame.width/6 + namelabelsize*3,self.view.frame.height/2,namelabelsize*10,namelabelsize))
        nametextfield.textAlignment = .Left
        nametextfield.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        nametextfield.borderStyle = .None
        nametextfield.delegate = self
        nametextfield.placeholder = "请输入您的姓名"
        nametextfield.setValue(UIColor(red: 42.0/255, green: 187.0/255, blue: 225.0/255, alpha: 0.7), forKeyPath: "placeholderLabel.textColor")
        self.view.addSubview(nametextfield)
        passwordfield = UITextField(frame: CGRectMake(self.view.frame.width / 6 + passwordsize * 3, self.view.frame.height / 2 + namelabelsize * 3, passwordsize * 10,passwordsize))
        passwordfield.borderStyle = .None
        passwordfield.textAlignment = .Left
        passwordfield.delegate = self
        //passwordfield.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        passwordfield.placeholder = "请输入您的学号"
        passwordfield.setValue(UIColor(red: 42.0/255, green: 187.0/255, blue: 225.0/255, alpha: 0.7), forKeyPath: "placeholderLabel.textColor")
        self.view.addSubview(passwordfield)
        deformationBtn = DeformationButton(frame: CGRectMake(self.view.frame.width / 6 + passwordsize * 3, self.view.frame.height / 2 + namelabelsize * 6, self.view.bounds.width / 2 - 50, namelabelsize * 2), color: getColor("e13536"))
        self.view.addSubview(deformationBtn)
        
        deformationBtn.forDisplayButton.setTitle("登陆", forState: UIControlState.Normal)
        deformationBtn.forDisplayButton.titleLabel?.font = UIFont.systemFontOfSize(15);
        deformationBtn.forDisplayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deformationBtn.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
     //   deformationBtn.forDisplayButton.setImage(UIImage(named:"微博logo.png"), forState: UIControlState.Normal)
        
        deformationBtn.addTarget(self, action: "waittime", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func waittime(){
        var timer : NSTimer?
        timer = NSTimer.scheduledTimerWithTimeInterval( 0.7, target: self, selector: "btnEvent", userInfo: nil, repeats: false)
    }
    
    func btnEvent(){
        manager.requestSerializer = zxf
        manager.responseSerializer = fxz
        let params : Dictionary<String,String> = ["stu_id" : passwordfield.text! , "stu_name" : nametextfield.text!]
        //Get方法访问接口
        manager.GET("http://www.szucal.com/api/1204/schedule.php?", parameters: params, success: {
            (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) in
            //将返回的14天的课程数据的Json内容转为字典
            let responseDict = responseObject as! NSDictionary!
            //判断，如果无返回数据则说明账号密码有误
            if(responseDict["schedule"] != nil)
            {
               // self.deformationBtn.isLoading = false
                //self.personmsgdata?.personmsg?.stu_id = self.passwordfield.text!
              //  self.personmsgdata?.setPersonmsg(self.passwordfield.text!, stu_name: self.nametextfield.text!)
              //  self.personmsgitem = Personmsgitem(self.passwordfield.text!, stu_name: self.nametextfield.text!)
                self.personmsgitem = Personmsgitem(stu_name: self.nametextfield.text! , stu_id: self.passwordfield.text!)
                self.personmsgdata.saveCheckLists(self.personmsgitem!)

                self.seccesslogin()
            }
            else
            {
                let alert = UIAlertView(title: "警告", message: "您的账号密码有误", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.deformationBtn.stopLoading()
            }
            
            }, failure: {(operation: AFHTTPRequestOperation!,
                error: NSError!) in
                //Handle Error
                print(error)
                print(operation.responseString)
                let alert = UIAlertView(title: "警告", message: "您的账号密码有误", delegate: self, cancelButtonTitle: "OK")
                alert.show()
        })

        //let timer : NSTimer?
       // timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "seccesslogin", userInfo: nil, repeats: true)
    }
    
    func seccesslogin(){
        stuname = self.nametextfield.text
        stuid = self.passwordfield.text
        let controller : UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("seccesslogin") as! UITabBarController
       // let controller : ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("aaa") as! ViewController
       // self.tabBarController?.presentViewController(controller, animated: true, completion: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func documentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        //let documentsDirectory : String = paths.first!
        return paths!
    }
    
    func dataFilePath()->String{
        return self.documentsDirectory().stringByAppendingString("/ABChecklists.plist")
    }
    
    func getColor(hexColor:String)->UIColor{
        var redInt:uint = 0
        var greenInt:uint = 0
        var blueInt:uint = 0
        var range = NSMakeRange(0, 2)
        
        NSScanner(string: (hexColor as NSString).substringWithRange(range)).scanHexInt(&redInt)
        range.location = 2
        NSScanner(string: (hexColor as NSString).substringWithRange(range)).scanHexInt(&greenInt)
        range.location = 4
        NSScanner(string: (hexColor as NSString).substringWithRange(range)).scanHexInt(&blueInt)
        
        return UIColor(red: (CGFloat(redInt)/255.0), green: (CGFloat(greenInt)/255.0), blue: (CGFloat(blueInt)/255.0), alpha: 1)
    }
    
}
