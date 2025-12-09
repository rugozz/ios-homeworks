//
//  LoginFactory.swift
//  Navigation
//
//  Created by Лисин Никита on 09.12.2025.
//

import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate
}
