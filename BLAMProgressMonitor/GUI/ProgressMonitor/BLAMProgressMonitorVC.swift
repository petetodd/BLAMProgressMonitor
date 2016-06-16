//
//  BLAMProgressMonitorVC.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 15/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import UIKit

class BLAMProgressMonitorVC: UIViewController {

    @IBOutlet weak var circleView: BGSUICircleView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        circleView.percentageComplete = NSNumber(float: 0.986) // Scale 0 - 1
        circleView.indicatorArcColor = UIColor.blueColor()
        circleView.fillColor = UIColor.lightGrayColor()
        circleView.lineWidth = 5
        circleView.fillAlpha = 0.3
        circleView.showPercentage = true
        circleView.lblText = "Migration"
        circleView.showPercentage = true
   //     [self.circleView setPercentageComplete:[NSNumber numberWithFloat:0.356]];

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
