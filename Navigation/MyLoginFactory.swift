//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by Лисин Никита on 09.12.2025.
//

import Foundation

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate {
        return LoginInspector()
    }
}
