//
//  Job+CoreDataProperties.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 19/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Job {

    @NSManaged var jobID: String?
    @NSManaged var jobDesc: String?
    @NSManaged var jobStatus: String?
    @NSManaged var percentageComplete: NSNumber?
    @NSManaged var message: String?
    @NSManaged var timeStarted: NSDate?
    @NSManaged var timeEnded: NSDate?
    @NSManaged var steps: NSSet?

}
