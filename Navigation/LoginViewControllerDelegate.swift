//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Лисин Никита on 08.12.2025.
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func checkCredentials(email: String, password: String)
    func signUp(email: String, password: String)
}
