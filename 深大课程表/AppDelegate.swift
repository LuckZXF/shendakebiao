//
//  AppDelegate.swift
//  推送
//
//  Created by 赵希帆 on 15/9/16.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var dataModel : DataModel?
    var personmsgData : PersonmsgData?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //var storyboard = UIStoryboard(name: "Main", bundle: nil)
        dataModel = DataModel()
        personmsgData = PersonmsgData()
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        let started = NSUserDefaults.standardUserDefaults().valueForKey("started")
        if started == nil {
            let vc = GuideVC()
            self.window?.rootViewController = vc
            
            vc.startClosure = {
                () -> Void in
                var storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let controller : loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginViewController") as! loginViewController
              //  self.window?.rootViewController = controller
                self.window?.rootViewController = controller
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue("start", forKey: "started")
                userDefaults.synchronize()
            }
        } else {
            if personmsgData?.personmsg?.stu_name == "" {
                print("s")
                //  let navigation = self.window?.rootViewController as! UINavigationController
                var storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let controller : loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginViewController") as! loginViewController
                self.window?.rootViewController = controller
            }
            else {
                stuid = personmsgData?.personmsg?.stu_id
                stuname = personmsgData?.personmsg?.stu_name
                var storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let controller1 : UITabBarController = storyboard.instantiateViewControllerWithIdentifier("seccesslogin") as! UITabBarController
                self.window?.rootViewController = controller1
                //  controller1.tabBarItem.image = UIImage(named: "tabbar2.png")
            }
            
        }
      //  self.window?.makeKeyAndVisible()
        
        //let tabbar = self.window?.rootViewController as! UITabBarController
      //  let controller : ViewController = tabbar.viewControllers?.first as! ViewController
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [ .Sound, .Alert, .Badge], categories: nil))
    /*    dataModel = DataModel()
        let navigation = self.window?.rootViewController as! UINavigationController
        let controller : AllListViewController = navigation.viewControllers.first as! AllListViewController
        controller.dataModel = dataModel!
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [ .Sound, .Alert, .Badge], categories: nil))*/
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    
    func saveData() {
        dataModel?.saveCheckLists()
        print("this is ok")
    }
    
}

