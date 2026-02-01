//
//  ProfileViewModelFactory.swift
//  Navigation
//
//  Created by Лисин Никита on 11.12.2025.
//

import UIKit

class ProfileViewModelFactory {
    
    static func createProfileViewModel(for login: String) -> ProfileViewModelProtocol {
        // Создаем UserService в зависимости от схемы сборки
        #if DEBUG
        let userService = TestUserService()
        #else
        let releaseUser = User(
            login: "admin",
            fullName: "Иван Иванов",
            avatar: UIImage(named: "avatar_placeholder"),
            status: "В сети"
        )
        let userService = CurrentUserService(user: releaseUser)
        #endif
        
        return ProfileViewModel(
            userService: userService,
            login: login
        )
    }
}
