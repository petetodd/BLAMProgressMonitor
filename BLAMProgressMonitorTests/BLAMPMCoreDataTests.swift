//
//  BLAMPMCoreDataTests.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 18/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import XCTest
import CoreData
@testable import BLAMProgressMonitor


class BLAMPMCoreDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testJobCreation(){
        //let moc = retrieveMOC()
        var dict = [String: AnyObject] ()
        dict["jobDesc"] = "Test job"
        dict["jobID"] = "Test ID"
        dict["jobStatus"] = "Started"
        dict["message"] = "Just started a test job"
        dict["percentageComplete"] = NSNumber(int: 0)
        BGSPMCoreData.sharedInstance.createPMJob(dict)
        // Test is job exists
        
        let predKey = NSPredicate(format: "jobID = %@", (dict["jobID"] as! String))
        let subPredicates = NSArray.init(array: [predKey])
        let predicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: subPredicates as! [NSPredicate])
        let job = BGSPMCoreData.sharedInstance.retrieveEntityWithPredicate("Job", predicate: predicate)
        // Does job exist
        XCTAssertNotNil(job)
        // Is it the right job
        guard let strDesc = job?.valueForKey("jobDesc") as? String else{
            XCTAssertFalse(true)
            return
        }

        XCTAssertEqual("Test job", strDesc )


        // Job Dictionary
        /*
         jobDesc
         jobID
         jobStatus
         message
         percentageComplete
         
 
 */
    
    }
    
    
    func retrieveMOC() -> NSManagedObjectContext{
        
        let managedObjectContext = BGSPMCoreData.sharedInstance.managedObjectContext
        
        return managedObjectContext

        
    }
    
    
    
}
