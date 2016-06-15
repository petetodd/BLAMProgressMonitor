//
//  ViewController.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 15/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    
    }
    
    private func displaySync(){
        if let topVC = UIApplication.topViewController(){
            let displayVC = BLAMProgressMonitorVC()
            let transitionManager = BGSTransitionCenteredModal()
            displayVC.transitioningDelegate = transitionManager
            topVC.presentViewController(displayVC, animated: true, completion: nil)
           
        }
    }

}

