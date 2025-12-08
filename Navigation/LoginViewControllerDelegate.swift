//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Лисин Никита on 08.12.2025.
//

import Foundation

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}
