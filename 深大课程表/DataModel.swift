//
//  DataModel.swift
//  推送
//
//  Created by 赵希帆 on 15/9/19.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    
    var lists = [Checklist]()
    override init() {
        super.init()
        self.loadChecklistItems()
        self.registerDefaults()
    }
    
    func saveCheckLists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklist")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func documentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        //let documentsDirectory : String = paths.first!
        return paths!
    }
    
    func dataFilePath()->String{
        return self.documentsDirectory().stringByAppendingString("/AAChecklists.plist")
    }
    
    func loadChecklistItems(){
        let path = self.dataFilePath()
      //  print("path:\(path)")
       // print(/var/mobile/Containers/Data/Application/05A765CE-A2FD-4F59-8A65-463B20152811/DocumentsChecklists.plist)
        let defaultManager = NSFileManager()
     //   print(defaultManager.fileExistsAtPath(path))
      //  print(NSDate(contentOfFile:path))
        if defaultManager.fileExistsAtPath(path) {
            let data = NSData(contentsOfFile: path)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            lists = unarchiver.decodeObjectForKey("Checklist") as! Array
            unarchiver.finishDecoding()
      //      print("111")
        }
        else{
            let checklist = Checklist(name: "第一个任务类型")
            lists.append(checklist)
            saveCheckLists()
        }
    }
    
    func indexofSelectedChecklist() -> Int{
        return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
    }
    
    func setIndexOfSelectedChecklist(index : Int)
    {
        NSUserDefaults.standardUserDefaults().setInteger(index, forKey: "ChecklistIndex")
    }
    
    func registerDefaults(){
        let dictionary : Dictionary<String,Int> = ["ChecklistIndex" : -1]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    //列表按字母顺序排序
    func sortCheckLists(){
        lists.sort(onSort)
    }
    
    func onSort(s1:Checklist,s2:Checklist)->Bool {
        return s1.name > s2.name
    }
    
    class func nextChecklistItemId()->Int{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemId = userDefaults.integerForKey("ChecklistItemId")
        userDefaults.setInteger(itemId+1, forKey: "ChecklistItemId")
        userDefaults.synchronize()
        return itemId
    }
    
}
