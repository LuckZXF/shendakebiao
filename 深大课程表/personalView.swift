//
//  personalView.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/17.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

var windows = Array<UIWindow!>()
var image1name : String = "my.png"
var image1 = UIImage(named: image1name)

class personalView : UITableViewController , UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIAlertViewDelegate {
    
    var timer : NSTimer?
    var persondata : PersonmsgData = PersonmsgData()
    var personitem : Personmsgitem?

   // var vi = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell = "cell"
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(Cell)
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: Cell)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //cell = UITableViewCellStyle.Subtitle
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.accessoryType = UITableViewCellAccessoryType.None
          //  let image1 = UIImage(named: "my")
            let fullPath : String = dataFilePath()
            let savedImage:UIImage? = UIImage(contentsOfFile: fullPath as String)
            if savedImage != nil {
                image1 = savedImage
            }
            let itemSize : CGSize = CGSizeMake(60,60)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
            let imageRect : CGRect = CGRectMake(0, 0, itemSize.width, itemSize.height)
            image1?.drawInRect(imageRect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cell!.textLabel?.text = stuname
            cell!.detailTextLabel?.text = stuid
            let button : UIButton = UIButton(frame: CGRectMake(0,0,76,76))
            
            button.addTarget(self, action: "chooseImageBtnPressed", forControlEvents: UIControlEvents.TouchDown)
            cell.contentView.addSubview(button)
            //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.textLabel?.text = "备忘提醒录"
            cell.imageView?.image = UIImage(named: "")
            return cell
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            cell.textLabel?.text = "功能介绍"
            cell.imageView?.image = UIImage(named: "")
            return cell
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            cell.textLabel?.text = "检查更新"
            cell.imageView?.image = UIImage(named: "")
            return cell
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            cell.textLabel?.text = "关于我们"
            cell.imageView?.image = UIImage(named: "")
            return cell
        }
        if indexPath.section == 3 && indexPath.row == 0 {
            cell.accessoryType = .None
            let height : CGFloat = cell.contentView.frame.height
            let width : CGFloat = cell.contentView.frame.width
            let exitLabel : UILabel = UILabel(frame: CGRectMake(width/2 - 15,height/10,3*width/4,4*height/5))
            exitLabel.text = "安全退出"
            exitLabel.font = UIFont.systemFontOfSize(17)
            exitLabel.textColor = UIColor.redColor()
            cell.contentView.addSubview(exitLabel)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 50
        }
        if section == 0 {
            return 40
        }
        else{
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            print("aaaa")
            let controller : AllListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AllList") as! AllListViewController
            let dataModel : DataModel = DataModel()
            controller.dataModel = dataModel
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            let v3 = self.storyboard?.instantiateViewControllerWithIdentifier("functionView") as! UIViewController!
            v3.view.backgroundColor = UIColor.whiteColor()
            self.navigationController?.pushViewController(v3, animated: true)
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            let frame = CGRectMake(0, 0, 78, 78)
            let window = UIWindow(frame: frame)
            let mainView = UIView(frame: frame)
            mainView.layer.cornerRadius = 12
            mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
            let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            ai.frame = CGRectMake(21, 10, 36, 36)
            ai.startAnimating()
            mainView.addSubview(ai)
            let pleaseLabel : UILabel = UILabel(frame: CGRectMake(10,52,70,12))
            pleaseLabel.text = "检查更新中"
            pleaseLabel.font = UIFont.systemFontOfSize(12)
            pleaseLabel.textColor = UIColor.whiteColor()
            mainView.addSubview(pleaseLabel)
            window.windowLevel = UIWindowLevelAlert
            window.center = (UIApplication.sharedApplication().keyWindow?.subviews.first as! UIView!).center
            window.hidden = false
            window.addSubview(mainView)
            windows.append(window)
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "updateAlertView", userInfo: nil, repeats: false )
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let v5 : UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("aboutus") as! UIViewController!
           // var v5 = UIViewController()
            v5.view.backgroundColor = UIColor.whiteColor()
            
           // let navigation : UINavigationController! = UINavigationController(rootViewController: v5)
          //  self.navigationController?.pushViewController(navigation, animated: true)
            self.navigationController?.pushViewController(v5, animated: true)
        }
        if indexPath.section == 3 && indexPath.row == 0 {
            self.personitem = Personmsgitem(stu_name: "", stu_id: "")
            self.persondata.saveCheckLists(personitem!)
            let controller : loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! loginViewController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func updateAlertView(){
        for i in windows {
            i.hidden = true
        }
        let alert = UIAlertView(title: "提示", message: "您已经是最新版本", delegate: self, cancelButtonTitle: "ok")
        alert.show()
        
    }
    
    func chooseImageBtnPressed() {
        print("qwer")
        let sheet:UIActionSheet
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            sheet = UIActionSheet(title: "选择", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: "从相册中选择", otherButtonTitles: "拍照", "取消")
        }else{
            sheet = UIActionSheet(title: "选择", delegate: self, cancelButtonTitle: nil , destructiveButtonTitle: "从相册中选择", otherButtonTitles: "取消")
        }
        sheet.tag = 255
        sheet.showInView(self.view)
  
    }
    
  /*  @IBAction func chooseImageBtnPressed(sender: AnyObject) {
        
        let sheet:UIActionSheet
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            sheet = UIActionSheet(title: "选择", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: "从相册中选择", otherButtonTitles: "拍照", "取消")
        }else{
            sheet = UIActionSheet(title: "选择", delegate: self, cancelButtonTitle: nil , destructiveButtonTitle: "从相册中选择", otherButtonTitles: "取消")
        }
        sheet.tag = 255
        sheet.showInView(self.view)
        
    }*/
    
    func documentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        //let documentsDirectory : String = paths.first!
        return paths!
    }
    
    func dataFilePath()->String{
        return self.documentsDirectory().stringByAppendingString("/ABChecklists.plist")
    }
    
    //保存图片至沙盒
    func saveImage(currentImage:UIImage,imageName:String){
        
        let imageData:NSData = UIImageJPEGRepresentation(currentImage, 0.5)!
        let fullPath:String = dataFilePath()
        imageData.writeToFile(fullPath, atomically: false)
    }
    
    //image picker delegte
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.saveImage(image, imageName: "currentImage.png")
        let fullPath:String = dataFilePath()
        let savedImage:UIImage = UIImage(contentsOfFile: fullPath as String)!
        image1 = savedImage
        tableView.reloadData()

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    //选择图片
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(actionSheet.tag == 255){
            var soureceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                switch(buttonIndex)
                {
                case 2://取消
                    return
                case 1://相机
                    soureceType = UIImagePickerControllerSourceType.Camera
                    break
                case 0: //相册
                    soureceType = UIImagePickerControllerSourceType.PhotoLibrary
                    break
                default:
                    return
                }
            }
            else
            {
                if(buttonIndex == 1){
                    return
                }else{
                    soureceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
                    //                    println("到此\(buttonIndex)")//1
                }
            }
            let imagePickerController:UIImagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = soureceType
            self.presentViewController(imagePickerController, animated: true, completion: { () -> Void in
            })
        }
    }
    
}
