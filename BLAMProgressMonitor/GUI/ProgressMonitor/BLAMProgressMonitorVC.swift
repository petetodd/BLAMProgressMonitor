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
    var jobLabel : String!
    
    
    @IBOutlet weak var circleView: BGSUICircleView!
    @IBOutlet weak var tableView: UITableView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   //     let dataSourceTV = tableView.dataSource as! BGSPMTableViewDataSource
     //   tableView.dataSource = dataSourceTV
        configGestures()
        // Create the job
        createJob()
    //    dataSourceTV.selectedJob = selectedJob
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateProgress), name: notificationProgress, object: nil)
        
        circleView.percentageComplete = NSNumber(float: 0.0) // Scale 0 - 1
        circleView.indicatorArcColor = UIColor.blueColor()
        circleView.fillColor = UIColor.lightGrayColor()
        circleView.lineWidth = 5
        circleView.fillAlpha = 0.3
        if jobLabel != nil{
            circleView.lblText = jobLabel
        }else{
            circleView.lblText = ""
        }
        circleView.showPercentage = true
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
    
    override func viewDidLayoutSubviews() {
 //       tableView.reloadData()
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
        if jobLabel != nil{
            dict["jobDesc"] = jobLabel
        }else{
            dict["jobDesc"] = "PM job"
        }
        
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
        self.tableView.reloadData()
        
        print("table view sections : \(tableView.numberOfSections)")

        

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

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return   1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedJob != nil{
            return (selectedJob.steps?.count)!
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cell = UITableViewCell()
        let sortDate = NSSortDescriptor.init(key: "timeStarted", ascending: false)
        let sortedSteps =   selectedJob.steps?.sortedArrayUsingDescriptors([sortDate])
        let jobStep = sortedSteps![indexPath.row] as! JobStep
        cell.textLabel?.text = jobStep.displayTitle()
        cell.backgroundColor = UIColor.clearColor()

        
        
        
        return cell
    }
    


}
