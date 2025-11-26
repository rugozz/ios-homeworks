//
//  TestUserService.swift
//  Navigation
//
//  Created by Лисин Никита on 26.11.2025.
//

import UIKit

// Класс TestUserService для тестовых данных в Debug схеме
class TestUserService: UserService {
    private let testUser: User
    
    init() {
        // Создаем тестового пользователя с другими данными
        self.testUser = User(
            login: "test",
            fullName: "Тестовый Пользователь",
            avatar: UIImage(systemName: "testtube.2"), // Иконка для тестового режима
            status: "Тестовый режим"
        )
    }
    
    func getUser(by login: String) -> User? {
        // В тестовом режиме возвращаем тестового пользователя для любого непустого логина
        return !login.isEmpty ? testUser : nil
    }
}
