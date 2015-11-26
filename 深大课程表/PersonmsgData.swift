//
//  personmsgData.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/20.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

class PersonmsgData : NSObject {
    
    var personmsg : Personmsgitem?
    
    override init() {
        super.init()
        self.loadChecklistItems()
        //self.registerDefaults()
    }
    
    func setPersonmsg(stu_id : String,stu_name : String)
    {
        personmsg = Personmsgitem(stu_name: stu_name, stu_id: stu_id)
    }
    
    func saveCheckLists(person : Personmsgitem) {
        print("save")
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(person, forKey: "Personmsg")
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
        return self.documentsDirectory().stringByAppendingString("/Personmsg5.plist")
    }
    
    func loadChecklistItems(){
        let path = self.dataFilePath()
       // print("path:\(path)")
        // print(/var/mobile/Containers/Data/Application/05A765CE-A2FD-4F59-8A65-463B20152811/DocumentsChecklists.plist)
        let defaultManager = NSFileManager()
        print(defaultManager.fileExistsAtPath(path))
        //  print(NSDate(contentOfFile:path))
        if defaultManager.fileExistsAtPath(path) {
            let data = NSData(contentsOfFile: path)
            print("sss")
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            personmsg = unarchiver.decodeObjectForKey("Personmsg") as! Personmsgitem
            unarchiver.finishDecoding()
            print(personmsg?.stu_id)
        }
        else{
            personmsg = Personmsgitem(stu_name: "", stu_id: "")
            saveCheckLists(personmsg!)
        }
    }

}
