//
//  MainItem.swift
//  推送
//
//  Created by 赵希帆 on 15/9/16.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

class MainItem: NSObject {
    
    var text :String
    
    var checked : Bool
    var dueDate : NSDate
    var shouldRemind : Bool
    var itemId : Int
    
    init(text : String , checked : Bool , dueDate : NSDate,shouldRemind : Bool){
        self.text = text
        self.checked = checked
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
        self.itemId = DataModel.nextChecklistItemId()
        super.init()
    }
    
    deinit{
        let existingNotification = self.notificationForThisItem() as UILocalNotification?
        if existingNotification != nil {
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
        }
    }
    
    func toggleChecked(){
        self.checked = !self.checked
    }
    
    required init!(coder aDecoder: NSCoder!) {
        self.text = aDecoder.decodeObjectForKey("Text") as! String
        self.checked = aDecoder.decodeObjectForKey("Checked") as! Bool
        self.dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        self.shouldRemind = aDecoder.decodeObjectForKey("ShouldRemind") as! Bool
        self.itemId = aDecoder.decodeObjectForKey("ItemId") as! Int
    }
    
    func encodeWithCoder(aCoder : NSCoder!) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeObject(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate,forKey: "DueDate")
        aCoder.encodeObject(shouldRemind, forKey:"ShouldRemind")
        aCoder.encodeObject(itemId, forKey: "ItemId")
    }
    
    func scheduleNotification(){
        let existingNotification = self.notificationForThisItem() as UILocalNotification?
        if existingNotification != nil {
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
        }
        
        if self.shouldRemind && (self.dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending){
            let localNotification = UILocalNotification()
            localNotification.fireDate = self.dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = self.text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID " : self.itemId]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    func notificationForThisItem()->UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        for notification in allNotifications! {
            var info : Dictionary<String,Int>? = notification.userInfo as? Dictionary<String, Int>
            let number = info?["ItemID"]
            if number != nil && number == self.itemId {
                return notification as? UILocalNotification
            }
        }
        return nil
    }
}
