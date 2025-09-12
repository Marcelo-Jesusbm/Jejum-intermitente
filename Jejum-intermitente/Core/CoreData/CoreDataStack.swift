//
//  CoreDataStack.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(inMemory: Bool = false) {
        let model = CoreDataModel.makeModel()
        persistentContainer = NSPersistentContainer(name: "FastingModel", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true
            persistentContainer.persistentStoreDescriptions = [description]
        } else {
            let description = NSPersistentStoreDescription()
            description.type = NSSQLiteStoreType
            description.shouldAddStoreAsynchronously = true
            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true
            persistentContainer.persistentStoreDescriptions = [description]
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ CoreData failed to load store: \(error)")
            }
        }

        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = persistentContainer.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }

    func save(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func performAndWait<T>(_ block: (NSManagedObjectContext) throws -> T) throws -> T {
        var result: Result<T, Error>!
        let context = viewContext
        context.performAndWait {
            do {
                let r = try block(context)
                result = .success(r)
            } catch {
                result = .failure(error)
            }
        }
        switch result! {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
