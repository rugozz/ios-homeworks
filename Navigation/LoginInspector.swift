//
//  LoginInspector.swift
//  Navigation
//
//  Created by Лисин Никита on 08.12.2025.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginInspector: LoginViewControllerDelegate {
    
    private let checkerService: CheckerServiceProtocol
    private weak var viewController: UIViewController?
    
    // Инициализатор с dependency injection
    init(checkerService: CheckerServiceProtocol = CheckerService.shared) {
        self.checkerService = checkerService
    }
    
    // Метод для установки ViewController (если нужно передать позже)
    func setViewController(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - LoginViewControllerDelegate Methods
    func checkCredentials(email: String, password: String) {
        // Проверяем, есть ли пользователь в БД
        checkerService.checkCredentials(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // Пользователь существует и пароль верный
                    self?.handleSuccessfulLogin(user: user)
                    
                case .failure(let error):
                    if let authError = error as NSError? {
                        if authError.code == AuthErrorCode.userNotFound.rawValue {
                            // Пользователь не найден - регистрируем нового
                            self?.signUp(email: email, password: password)
                        } else {
                            // Другая ошибка (неверный пароль и т.д.)
                            self?.showAlert(message: self?.getErrorMessage(from: authError) ?? error.localizedDescription)
                        }
                    } else {
                        self?.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        // Регистрируем нового пользователя
        checkerService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // Успешная регистрация
                    self?.showAlert(message: "Регистрация прошла успешно!", isError: false)
                    self?.handleSuccessfulLogin(user: user)
                    
                case .failure(let error):
                    self?.showAlert(message: "Ошибка регистрации: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleSuccessfulLogin(user: User) {
        // Сохраняем данные пользователя
        UserDefaults.standard.set(user.login, forKey: "currentUserEmail")
        UserDefaults.standard.set(user.fullName, forKey: "currentUserName")
        
        // Переходим на следующий экран
        if let loginVC = viewController as? LogInViewController {
            loginVC.handleSuccessfulLogin(login: user.login)
        }
    }
    
    private func showAlert(message: String, isError: Bool = true) {
        let alert = UIAlertController(
            title: isError ? "Ошибка" : "Успех",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    private func getErrorMessage(from error: NSError) -> String {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return error.localizedDescription
        }
        
        switch errorCode {
        case .wrongPassword:
            return "Неверный пароль. Попробуйте снова."
        case .userNotFound:
            return "Пользователь не найден. Будет выполнена регистрация."
        case .invalidEmail:
            return "Неверный формат email"
        case .networkError:
            return "Ошибка сети. Проверьте подключение"
        case .emailAlreadyInUse:
            return "Этот email уже зарегистрирован"
        case .weakPassword:
            return "Пароль должен содержать минимум 6 символов"
        default:
            return error.localizedDescription
        }
    }
}
