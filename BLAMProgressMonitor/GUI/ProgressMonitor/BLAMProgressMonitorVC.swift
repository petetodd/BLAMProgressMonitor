//
//  BLAMProgressMonitorVC.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 15/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import UIKit
import CoreData

class BLAMProgressMonitorVC: UIViewController {

    let notificationProgress = "com.brightbluecircle.circleViewProgress"
    var selectedJob : Job!
    
    
    @IBOutlet weak var circleView: BGSUICircleView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGestures()
        // Create the job
        createJob()

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
            if let stepDict = info["stepDict"]{
                updateJobStep(stepDict as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    @IBAction func butCancelAction(sender: AnyObject) {
        dismissView()
    }
    // MARK: - Create Job in Core Data
    // Used to log job enable reporting on progress of previous jobs
    func createJob(){
        var dict = [String: AnyObject] ()
        dict["jobDesc"] = "Test job"
        dict["jobID"] = uniqueStringID()
        dict["jobStatus"] = "Started"
        dict["message"] = "Just started a test job"
        dict["percentageComplete"] = NSNumber(int: 0)
        selectedJob = BGSPMCoreData.sharedInstance.createPMJob(dict) as! Job
        BGSPMCoreData.sharedInstance.saveContext()
    }
    
    func updateJobStep(dictIn : Dictionary<String, AnyObject>) {
        // Record job and status
        var dict = [String: AnyObject] ()
        if dictIn["message"] != nil{
            dict["message"] = dictIn["message"] as! String
        }else{
            dict["message"] = "--"
        }
        if dictIn["status"] != nil{
            dict["status"] = dictIn["status"] as! String
        }else{
            dict["status"] = "--"
        }
        if dictIn["stepDesc"] != nil{
            dict["stepDesc"] = dictIn["stepDesc"] as! String
        }else{
            dict["stepDesc"] = "--"
        }
        if dictIn["stepID"] != nil{
            dict["stepID"] = dictIn["stepID"] as! String
        }else{
            dict["stepID"] = "--"
        }
        let jobStep = BGSPMCoreData.sharedInstance.createPMJobStep(dict) as! JobStep
        jobStep.job = selectedJob
        BGSPMCoreData.sharedInstance.saveContext()

    }

    
    func uniqueStringID()-> String{
        let strUnique = NSProcessInfo().globallyUniqueString
        return strUnique
    }
    
    // MARK: - Deinit (Notification)
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


}
