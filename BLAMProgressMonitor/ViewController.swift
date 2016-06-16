//
//  ViewController.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 15/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let notificationProgress = "com.brightbluecircle.circleViewProgress"


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func displayButAction(sender: AnyObject) {
        
        displaySync()
        // Run demo calls to update Progress Momnitor on a new thread
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.progressUIDemo()
        }

        // Run a test to show update of progress
        //displaySyncDemo()

    }
    
    private func displaySync(){
        if let topVC = UIApplication.topViewController(){
            let displayVC = BLAMProgressMonitorVC()
            let transitionManager = BGSTransitionCenteredModal()
            displayVC.transitioningDelegate = transitionManager
            topVC.presentViewController(displayVC, animated: true, completion: nil)
           
        }
    }
    
    private func displaySyncDemo(){
        if let topVC = UIApplication.topViewController(){
            let displayVC = BLAMProgressMonitorVC()
            let transitionManager = BGSTransitionCenteredModal()
            displayVC.transitioningDelegate = transitionManager
            topVC.presentViewController(displayVC, animated: true, completion: { (finished) -> Void in
                self.progressUIDemo()
            })
            
        }
    }
    
    
    


    
    private func progressUIDemo(){
        // Set the speed of the demo
        let date = NSDate()
        var timestamp = UInt64(floor(date.timeIntervalSince1970 * 1000))
        let delayMicroSec: UInt64 = 10000000
        
        var dataDict = Dictionary<String, AnyObject>()
        
        for i in 0 ..< 101 { // 0 to 100 percent
            // Lets loop some time
            let newTimeStamp = timestamp + delayMicroSec
            while timestamp < newTimeStamp {
                // Hang around a bit - its a Demo!!
                timestamp = timestamp + UInt64(1)
            }
            timestamp = UInt64(floor(date.timeIntervalSince1970 * 1000))
            let floatPercent = Float(i) / 100
            dataDict["percent"] = NSNumber(float: floatPercent)
            print("DEBUG complete: \(i) ")
            // Dispath notification on main thread
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName(self.notificationProgress, object:self , userInfo: dataDict)
            }

        


        }

    }

}

