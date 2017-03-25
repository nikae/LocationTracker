//
//  CoreDataStack.swift
//  Trail Lab
//
//  Created by Nika on 12/11/16.
//  Copyright © 2016 Nika. All rights reserved.
//

import Foundation
import CoreData

//class CoreDataStack {
//    @available(iOS 10.0, *)
//    lazy var parsistentContainer: NSPersistentContainer = {
//     let container = NSPersistentContainer(name: "DataBaseModel")
//        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("\(error),\(error.userInfo)")
//            }
//            
//            })
//        return container
//    }()
//    
//    func saveContext() {
//        if #available(iOS 10.0, *) {
//            let context = parsistentContainer.viewContext
//        } else {
//            // Fallback on earlier versions
//        }
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                 let error = error as NSError
//                    fatalError("\(error),\(error.userInfo)")
//
//            }
//        }
//    }
//    
//}
























