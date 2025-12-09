//
//  LoginInspector.swift
//  Navigation
//
//  Created by Лисин Никита on 08.12.2025.
//

import Foundation

class LoginInspector: LoginViewControllerDelegate {
    
    // Реализация метода протокола
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}
