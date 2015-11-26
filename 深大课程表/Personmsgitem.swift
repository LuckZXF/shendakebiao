//
//  Personmsgitem.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/20.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

class Personmsgitem : NSObject {
    //学生姓名
    var stu_name : String
    //学生学号
    var stu_id : String
    
    init(stu_name : String , stu_id : String) {
        self.stu_name = stu_name
        self.stu_id = stu_id
        super.init()
    }
    
    required init!(coder aDecoder:NSCoder!){
        self.stu_name = aDecoder.decodeObjectForKey("Stu_name") as! String
        self.stu_id = aDecoder.decodeObjectForKey("Stu_id") as! String
    }
    
    func encodeWithCoder(aCoder : NSCoder!) {
        aCoder.encodeObject(stu_id, forKey: "Stu_id")
        aCoder.encodeObject(stu_name, forKey: "Stu_name")
    }
    
    
}
