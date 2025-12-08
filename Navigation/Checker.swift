//
//  Checker.swift
//  Navigation
//
//  Created by Лисин Никита on 08.12.2025.
//

import Foundation

// Синглтон для проверки логина и пароля
class Checker {
    static let shared = Checker()
    
    // Приватные константы с зарегистрированными данными
    private let registeredLogin = "admin"
    private let registeredPassword = "12345"
    
    // Приватный инициализатор для синглтона
    private init() {}
    
    // Метод проверки логина и пароля
    func check(login: String, password: String) -> Bool {
        return login == registeredLogin && password == registeredPassword
    }
}

