//
//  BGSPMCoreData.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 18/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//
//  Progress Monitor uses Core Data to persist an activity log


import UIKit
import CoreData

class BGSPMCoreData {
    
    static let sharedInstance = BGSPMCoreData()  // UsageBGSCurrencyPickerCoreData.sharedInstance
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.brightgreenstar.swiftCoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("BGSPMDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("BGSPMData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "BGSPMData Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.brightbluecirlce.bgspmdata", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("BGSPMData Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () -> String {
      //  let setUpdatedObject = managedObjectContext.updatedObjects
        let setInsertedObjects = managedObjectContext.insertedObjects
     //   let setDeletedObjects = managedObjectContext.deletedObjects
        if setInsertedObjects.count > 0 {
            print("DEBUG BGSPMData managedObjectContext saveContext ")
            // For inserted Objects populate last updated date, user and hash
            if setInsertedObjects.count > 0{
                for object in setInsertedObjects{
                    let managedObj = object as NSManagedObject
                    let managedObjDesc = managedObj.entity
                    let dictAttribs: Dictionary = managedObjDesc.attributesByName
                    
                    if (dictAttribs["timeStarted"] != nil){   // This is new record so set start time to now
                        //Update to current date
                        let date = NSDate()
                        managedObj.setValue(date, forKey: "timeStarted")
                    }
                }
            }

            
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("BGSPMData Unresolved error \(nserror), \(nserror.userInfo)")
                //abort()
                return("ERROR")
            }
            return("SAVED")
        }else{
            // Just do a normal save for updated or deleted entities
            do {
                try managedObjectContext.save()
            } catch {
                return ("ERROR")
            }
            return("SAVED")
        }
        
    }
    
    // MARK: - BGS PM support
    // MARK: Create a new job
    func createPMJob(dictIn : Dictionary<String, AnyObject>) -> NSManagedObject?{
        let job =  NSEntityDescription.insertNewObjectForEntityForName("Job", inManagedObjectContext: self.managedObjectContext)

        for (key, value) in dictIn{
            job.setValue(value, forKey: key)
        }
        return job
    }
    
    func createPMJobStep(dictIn : Dictionary<String, AnyObject>) -> NSManagedObject?{
        let jobStep =  NSEntityDescription.insertNewObjectForEntityForName("JobStep", inManagedObjectContext: self.managedObjectContext)
        
        for (key, value) in dictIn{
            jobStep.setValue(value, forKey: key)
        }
        return jobStep
    }


    // MARK: - Core Data query support
    // MARK: Retrieve Entity with predicate
    func retrieveEntityWithPredicate(entityWithName : String, predicate : NSCompoundPredicate) -> NSManagedObject?
    {
        // Create a new fetch request using the CapitalAsset entity
        let fetchRequest = NSFetchRequest(entityName: entityWithName)
        fetchRequest.predicate = predicate
        
        // Execute the fetch request, and cast the results to an array of CapitalAsset objects
        do
        {
            if let  fetchedResultsArray = try managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                let arrayResults = NSMutableArray(array: fetchedResultsArray)
                if arrayResults.count > 0{
                    return arrayResults[0] as? NSManagedObject
                }
            }
            
            
        } catch
        {
            print(error)
        }
        return nil
    }
    
    
}
