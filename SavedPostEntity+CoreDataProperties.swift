//
//  SavedPostEntity+CoreDataProperties.swift
//  Navigation
//
//  Created by Лисин Никита on 26.04.2026.
//
//

import Foundation
import CoreData


extension SavedPostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedPostEntity> {
        return NSFetchRequest<SavedPostEntity>(entityName: "SavedPostEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?

}

extension SavedPostEntity : Identifiable {

}
