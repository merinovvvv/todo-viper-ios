//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 31.03.26.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
