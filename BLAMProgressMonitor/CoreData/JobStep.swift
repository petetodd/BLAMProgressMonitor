//
//  JobStep.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 19/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import Foundation
import CoreData


class JobStep: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func dateAsTimeString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if timeStarted != nil{
            let strDate = dateFormatter.stringFromDate(timeStarted!)
            return strDate
        }else {
            return ""
        }
    }
    
    func displayTitle() -> String{
        let strTitle = ("\(message!): \(status!): \(dateAsTimeString())")
        return strTitle
        
    }

}
