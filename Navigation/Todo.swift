//
//  Todo.swift
//  Navigation
//
//  Created by Лисин Никита on 23.04.2026.
//

import Foundation

// MARK: - Модель данных
struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    // Инициализатор из словаря для JSONSerialization
    init?(dictionary: [String: Any]) {
        guard let userId = dictionary["userId"] as? Int,
              let id = dictionary["id"] as? Int,
              let title = dictionary["title"] as? String,
              let completed = dictionary["completed"] as? Bool else {
            return nil
        }
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
}
