//
//  BGSPMTableViewDataSource.swift
//  BLAMProgressMonitor
//
//  Created by Peter Todd Air on 18/06/2016.
//  Copyright © 2016 Bright Green Star. All rights reserved.
//

import UIKit
import CoreData

class BGSPMTableViewDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    var fetchedResultsController : NSFetchedResultsController!

    
    func populateArrayData()
    {
        /*
        let managedObjectContect = BGSAssetCoreData.sharedInstance.managedObjectContext
        // Create a new fetch request using the CapitalAsset entity
        let fetchRequest = NSFetchRequest(entityName: "Tenant")
        // We want a dictionary of assets by country
        
        let sortAddress = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortAddress]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContect, sectionNameKeyPath: "strIndexLetter", cacheName: nil)
        fetchedResultsController.delegate = self
        
        
        // Execute the fetch request, and cast the results to an array of CapitalAsset objects
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
 */
        
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if fetchedResultsController.sections?.count > 0{
            return (fetchedResultsController.sections?.count)!
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController.sections?.count == 0{
            return 0
        }
        
        return fetchedResultsController.sections![section].numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cell = UITableViewCell()
        
        
        
        return cell
    }

}
