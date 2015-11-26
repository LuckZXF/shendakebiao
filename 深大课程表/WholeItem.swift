//
//  WholeItem.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/19.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

let introduce : String! = "    此App为测试产品，岗位实践4项目。赵希帆负责原生态IOS，后台服务器。杨银清负责Html5页面"
let manager = AFHTTPRequestOperationManager()
var zxf : AFJSONRequestSerializer = AFJSONRequestSerializer()
var fxz : AFJSONResponseSerializer = AFJSONResponseSerializer()
var stuname : String!
var stuid : String!
var courseArray : NSArray = NSArray()
var arrTitle : [String]!
var arrDetail : [String]!
