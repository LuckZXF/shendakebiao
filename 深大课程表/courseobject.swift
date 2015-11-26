//
//  courseobject.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/23.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

class courseobject : NSObject {
    
    var courseid : String?
    var coursename : String?
    var course_teachername : String?
    var stu_name : String?
    var stu_pingjia : String?
    
    init(courseid : String,coursename : String,course_teachername : String,stu_name : String,stu_pingjia : String) {
        self.courseid = courseid
        self.coursename = coursename
        self.course_teachername = course_teachername
        self.stu_name = stu_name
        self.stu_pingjia = stu_pingjia
    }
}
