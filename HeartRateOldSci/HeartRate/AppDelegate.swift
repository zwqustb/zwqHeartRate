//
//  AppDelegate.swift
//  HeartRate
//
//  Created by zhangwenqiang on 2018/8/2.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

import UIKit
import CoreData
import SciChart
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SCIChartSurface.setRuntimeLicenseKey("<LicenseContract><Customer>BOE Healthcare Co.,Ltd.m</Customer><OrderId>ABT170215-1846-65104</OrderId><LicenseCount>1</LicenseCount><IsTrialLicense>false</IsTrialLicense><SupportExpires>03/01/2018 00:00:00</SupportExpires><ProductCode>SC-IOS-ANDROID-2D-ENTERPRISE-SRC</ProductCode><KeyCode>bd25a4d96985cc4398954a3f09c0fb6a8600a611f6764e8c90a22bd369b784fa6299f8eb2dd5e937614c780a10a84e1a2d3e50cc2d49cd72983dcf3ece0e184f62f854e40d8698ff54b2321626d71ecd476af4f52eeb26032c12887ad6271f659fb952ce61ca0d05fd664b196d34fadcf50a0cd46de44ec2cc3fac3957bd676b691b1e8d3dbe3cbc1e5dde86cd7053bbabeea427a4d84a5f5950503f75e810acc78c877518a03fb3f392650be08fb9e37fada1e2c530c2b56875b35ceb9c66e2cee19b</KeyCode></LicenseContract>")
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       // self.saveContext()
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "HeartRate")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

