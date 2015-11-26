//
//  mainViewController.swift
//  深大课程表
//
//  Created by 赵希帆 on 15/11/14.
//  Copyright © 2015年 赵希帆. All rights reserved.
//

import UIKit

class mainViewController : UIViewController {
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url : NSURL! = NSURL(string: "http://www.shenzhendaxue.sinaapp.com")
        let request : NSURLRequest = NSURLRequest(URL: url)
        self.view.addSubview(webView)
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
