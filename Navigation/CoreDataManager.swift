//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Лисин Никита on 26.04.2026.
//

import CoreData
import UIKit
import StorageService

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Navigation")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func savePost(_ post: Post) {
        let savedPost = SavedPostEntity(context: context)
        savedPost.title = post.title
        savedPost.createdAt = Date()
        saveContext()
    }
    
    func fetchSavedPosts() -> [SavedPostEntity] {
        let request: NSFetchRequest<SavedPostEntity> = SavedPostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func isPostSaved(_ post: Post) -> Bool {
        let request: NSFetchRequest<SavedPostEntity> = SavedPostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", post.title)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    func deletePost(_ savedPost: SavedPostEntity) {
        context.delete(savedPost)
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
