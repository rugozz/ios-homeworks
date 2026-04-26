//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Лисин Никита on 24.04.2026.
//

import Foundation

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}
