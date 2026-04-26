//
//  CheckerService.swift
//  Navigation
//
//  Created by Лисин Никита on 24.04.2026.
//

import Foundation
import FirebaseAuth

class CheckerService: CheckerServiceProtocol {
    
    static let shared = CheckerService()
    
    private init() {}
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult,
            error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])))
                return
            }
            
            // Создаем пользователя из Firebase User
            let user = User(
                login: firebaseUser.email ?? "",
                fullName: firebaseUser.displayName ?? "Пользователь",
                avatar: nil,
                status: "В сети"
            )
            
            completion(.success(user))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, any Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult,
            error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка создания пользователя "])))
                return
            }
            
            let user = User(
                login: firebaseUser.email ?? "",
                fullName: "Новый пользователь",
                avatar: nil,
                status: "В сети"
            )
            
            completion(.success(user))
        }
    }
}
