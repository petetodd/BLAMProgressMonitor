//
//  BLAMProgressMonitorVC.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 15/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import UIKit

class BLAMProgressMonitorVC: UIViewController {

    let notificationProgress = "com.brightbluecircle.circleViewProgress"
    
    
    @IBOutlet weak var circleView: BGSUICircleView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGestures()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateProgress), name: notificationProgress, object: nil)

        
        
        
        circleView.percentageComplete = NSNumber(float: 0.0) // Scale 0 - 1
        circleView.indicatorArcColor = UIColor.blueColor()
        circleView.fillColor = UIColor.lightGrayColor()
        circleView.lineWidth = 5
        circleView.fillAlpha = 0.3
        circleView.showPercentage = true
        circleView.lblText = "Migration"
        circleView.showPercentage = true
        
        circleView.contentMode = UIViewContentMode.Redraw
    }
    
    func configGestures()
    {
        let tapDismis = UITapGestureRecognizer()
        tapDismis.addTarget(self, action: #selector(dismissView))
        self.circleView.addGestureRecognizer(tapDismis)
    }
    
    func dismissView(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    func updateProgress(notification: NSNotification){
        // First try to cast user info to expected type
        if let info = notification.userInfo as? Dictionary<String,AnyObject> {
            if let s = info["status"] {
                print(s)
                if s as! String == "COMPLETE"{
                    dismissViewControllerAnimated(true, completion: nil)
                    return
                }
            }
            
            if let percent = info["percent"]{
                let percentComplete = percent as! NSNumber
                print("DEBUG percent complete cirlce : \(percentComplete)")
                circleView.percentageComplete = percentComplete
                circleView.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Deinit (Notification)
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


}
