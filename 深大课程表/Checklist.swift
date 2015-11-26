//
//  Checklist.swift
//  推送
//
//  Created by 赵希帆 on 15/9/17.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    
    var name: String = ""
    var items = [MainItem]()
    
    init(name : String){
        self.name = name
    }
    
     required init!(coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObjectForKey("Name") as! String
        self.items = aDecoder.decodeObjectForKey("Items") as! [MainItem]
        
    }
    
    func encodeWithCoder(aCoder : NSCoder!) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int{
        var count = 0
        for item in items {
            if item.checked != true {
                count++
            }
        }
        return count
    }
    
}
