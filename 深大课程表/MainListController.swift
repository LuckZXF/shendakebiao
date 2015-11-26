//
//  MainListController.swift
//  推送
//
//  Created by 赵希帆 on 15/9/16.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

protocol MainListControllerDelegate {
    func addItemDidCancel (controller : MainListController)
    func addItem(controller:MainListController,didFinishAddingItem item : MainItem)
    func addItem(controller:MainListController,didFinishEditingItem item: MainItem)
}

class MainListController: UITableViewController , UITextFieldDelegate{
    
    @IBOutlet weak var SwitchControl: UISwitch!
    
    @IBOutlet weak var DueDateLabel: UILabel!
    
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    @IBOutlet weak var TextField: UITextField!
    
    var delegate : MainListControllerDelegate?
    var itemToEdit : MainItem?
    var dueDate : NSDate?
    var datePickerVisible : Bool = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //textField.delegate = self
        TextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextField.delegate = self
        //textField.becomeFirstResponder()
        if itemToEdit != nil {
            self.title = "编辑任务"
            self.TextField.text = itemToEdit?.text
            self.DoneButton.enabled = true
            SwitchControl.on = itemToEdit!.shouldRemind
            dueDate = self.itemToEdit?.dueDate
        }
        else{
            self.SwitchControl.on = false
            dueDate = NSDate()
        }
        upDateDueDateLabel()
        //showDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        delegate?.addItemDidCancel(self)
    }
    
    @IBAction func Done(sender: AnyObject) {
        if itemToEdit == nil {
            let item = MainItem(text: TextField.text!, checked: false, dueDate : self.dueDate!, shouldRemind : self.SwitchControl.on)
            item.scheduleNotification()
            delegate?.addItem(self, didFinishAddingItem: item)
            
        }
        else{
            self.itemToEdit?.text = self.TextField.text!
            self.itemToEdit?.shouldRemind = self.SwitchControl.on
            self.itemToEdit?.dueDate = self.dueDate!
            self.itemToEdit?.scheduleNotification()
            delegate?.addItem(self, didFinishEditingItem: self.itemToEdit!)
        }
    }
    
    //显示时间样式
    func upDateDueDateLabel(){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        self.DueDateLabel.text = formatter.stringFromDate(self.dueDate!)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DatePickerCell")
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                let datePicker = UIDatePicker(frame: CGRectMake(0.0, 0.0, 320.0, 216.0))
                datePicker.tag = 100
                datePicker.addTarget(self, action: "dateChanged:", forControlEvents: UIControlEvents.ValueChanged)
                cell?.contentView.addSubview(datePicker)
            }
            return cell!
        }
        else{
            return super.tableView(tableView, cellForRowAtIndexPath : indexPath)
        }
    }
    
    //响应dateChanged
    func dateChanged(datePicker : UIDatePicker)
    {
        self.dueDate = datePicker.date
        upDateDueDateLabel()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        TextField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1{
            print(datePickerVisible)
            if datePickerVisible == false {
                self.showDatePicker()
                
            }
            else{
                self.hideDatePicker()
            }
        }else{
            if datePickerVisible == true{
                self.hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return 217.0
        }else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            let newIndexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            return super.tableView(tableView , indentationLevelForRowAtIndexPath: newIndexPath)
            
        }
        else{
            return super.tableView(tableView , indentationLevelForRowAtIndexPath : indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible == true {
            return 3
        }
        else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    //显示日期选择器
    func showDatePicker(){
        datePickerVisible = true
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        self.tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    //关闭日期选择器
    func hideDatePicker(){
        if (datePickerVisible == true) {
            datePickerVisible = false
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            self.tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    //编辑任务时候关闭日期选择器
    func textFieldDidBeginEditing(textField: UITextField) {
        self.hideDatePicker()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newText = textField.text!.stringByReplacingCharactersInRange(range.toRange(textField.text!), withString: string)
        DoneButton.enabled = newText.characters.count > 0
        return true
    }
    
}

extension NSRange
{
    func toRange(string : String) -> Range<String.Index>{
        let startIndex = string.startIndex.advancedBy(self.location)
        let endIndex = startIndex.advancedBy(self.length)
        return startIndex..<endIndex
    }
}
