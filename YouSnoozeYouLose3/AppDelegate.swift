//
//  AppDelegate.swift
//  YouSnoozeYouLose3
//
//  Created by Tyler hostager on 8/3/15.
//  Copyright © 2015 Tyler hostager. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Init Parse framework
        Parse.enableLocalDatastore();
        Parse.setApplicationId("ASna5zhM1oPopmrPEsTIzdohzDV2YcKUQosm2fAh",
            clientKey: "VRUGIJMR8wXiE98pMeYf9yT7M0jceUWDHkcZdWlD");
        
        // Init Parse analytics
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
        
        /*//TEST
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.");
        }*///
        
        /* TEST
        let tableVC: AlarmsTableViewController = AlarmsTableViewController(className: "Alarm");
        tableVC.title = "Alarms";
        
        
        UINavigationBar.appearance().tintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0);
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0);
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        UIApplication.sharedApplication().statusBarHidden = false;
        
        
        let navigationVC = UINavigationController(rootViewController: tableVC);
        let frame = UIScreen.mainScreen().bounds;
        
        window = UIWindow(frame: frame);
        window!.rootViewController = navigationVC;
        window!.makeKeyAndVisible();
        */
        
        return true;
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

