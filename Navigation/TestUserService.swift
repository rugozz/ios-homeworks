//
//  TestUserService.swift
//  Navigation
//
//  Created by Лисин Никита on 26.11.2025.
//

import UIKit

// Класс TestUserService для тестовых данных в Debug схеме
class TestUserService: UserService {
    func getUser(by login: String) -> User? {
        // В тестовом режиме возвращаем пользователя с введенным логином
        guard !login.isEmpty else { return nil }
        
        return User(
            login: login,
            fullName: "Тестовый Пользователь (\(login))",
            avatar: UIImage(systemName: "testtube.2"),
            status: "Тестовый режим"
        )
    }
}
