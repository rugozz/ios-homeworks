//
//  User.swift
//  Navigation
//
//  Created by Лисин Никита on 26.11.2025.
//

import UIKit

// Класс User для хранения информации о пользователе
class User {
    let login: String
    let fullName: String
    let avatar: UIImage?
    let status: String
    
    init(login: String, fullName: String, avatar: UIImage? = nil, status: String = "Online") {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

// Протокол UserService
protocol UserService {
    func getUser(by login: String) -> User?
}

// Класс CurrentUserService
class CurrentUserService: UserService {
    private let currentUser: User
    
    init(user: User) {
        self.currentUser = user
    }
    
    func getUser(by login: String) -> User? {
        return currentUser.login.lowercased() == login.lowercased() ? currentUser : nil
    }
}
