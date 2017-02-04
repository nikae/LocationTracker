//
//  CoreDataStack.swift
//  locationTrackTest
//
//  Created by Nika on 12/11/16.
//  Copyright © 2016 Nika. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var parsistentContainer: NSPersistentContainer = {
     let container = NSPersistentContainer(name: "DataBaseModel")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(error),\(error.userInfo)")
            }
            
            })
        return container
    }()
    
    func saveContext() {
        let context = parsistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                 let error = error as NSError
                    fatalError("\(error),\(error.userInfo)")

            }
        }
    }
    
}
























