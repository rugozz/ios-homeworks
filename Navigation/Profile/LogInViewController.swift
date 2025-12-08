//
//  LogInViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 06.06.2025.
//

import UIKit
// Расширение для изменения прозрачности UIImage
extension UIImage {
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class LogInViewController: UIViewController, UITextFieldDelegate {

    // Делегат для проверки логина/пароля
    var loginDelegate: LoginViewControllerDelegate?
    
    // Обновляем свойство userService с условием компиляции
    private var userService: UserService {
        #if DEBUG
        // В Debug схеме используем TestUserService
        return TestUserService()
        #else
        // В Release схеме используем CurrentUserService
        let releaseUser = User(
            login: "admin",
            fullName: "Иван Иванов",
            avatar: UIImage(named: "avatar_placeholder"),
            status: "В сети"
        )
        return CurrentUserService(user: releaseUser)
        #endif
    }
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
        
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email or Phone"
        textField.layer.cornerRadius = 10
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    
    private let enterView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        return button
        
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .systemGray6
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
        setupConstraints()
        configureLoginButton()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // Метод для настройки кнопки
    private func configureLoginButton() {
        guard let normalImage = UIImage(named: "blue_pixel") else {
            print("Warning")
            return
        }
        // Создаем растягиваемые версии изображений
        let resizableNormal = normalImage.resizableImage(
            withCapInsets: UIEdgeInsets.zero,
            resizingMode: .stretch
        )
        
        let resizableHighlighted = normalImage.withAlpha(0.8)?.resizableImage(
            withCapInsets: UIEdgeInsets.zero,
            resizingMode: .stretch
        )
        
        // Устанавливаем изображения для разных состояний
        loginButton.setBackgroundImage(resizableNormal, for: .normal)
        loginButton.setBackgroundImage(resizableHighlighted, for: .highlighted)

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    

    @objc private func loginButtonTapped() {
        guard let login = loginTextField.text, !login.isEmpty else {
            showAlert(message: "Введите логин")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Введите пароль")
            return
        }
        
        guard let delegate = loginDelegate else {
            showAlert(message: "Ошибка инициализации")
            return
        }
        
        let isValidCredentials = delegate.check(login: login, password: password)
        
        if isValidCredentials {
            // Если логин/пароль верные, получаем информацию о пользователе
            
            if let user = userService.getUser(by: login) {
                // Успешная авторизация - переходим на экран профиля
                let profileVC = ProfileViewController()
                profileVC.user = user // Передаем пользователя
                
                // Добавляем информацию о типе сервиса для отладки
#if DEBUG
                print("DEBUG: Используется TestUserService")
                profileVC.debugInfo = "Debug сборка - Тестовый пользователь"
#else
                print("RELEASE: Используется CurrentUserService")
                profileVC.debugInfo = "Release сборка - Продакшен пользователь"
#endif
                
                navigationController?.pushViewController(profileVC, animated: true)
            } else {
                // Неверный логин
                showAlert(message: "Неверный логин или пароль")
            }
        }
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(loginButton)
        contentView.addSubview(stackView)
        contentView.addSubview(enterView2)
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)


    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
            setupKeyboardObservers()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            removeKeyboardObservers()
        }
        
        // MARK: - Actions
        
        @objc func willShowKeyboard(_ notification: NSNotification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                    scrollView.verticalScrollIndicatorInsets = scrollView.contentInset
            
        }
        
        @objc func willHideKeyboard(_ notification: NSNotification) {
            scrollView.contentInset = .zero
            scrollView.verticalScrollIndicatorInsets = .zero
        }
    
    private func setupConstraints() {
        // Констрейнты для ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Констрейнты для ContentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Констрейнты для элементов
        NSLayoutConstraint.activate([
            // Логотип
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            // Поле логина
            loginTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            loginTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Поле пароля
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Разделение между логином и паролем
            enterView2.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50),
            enterView2.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            enterView2.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            enterView2.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Кнопка входа
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willShowKeyboard(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willHideKeyboard(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
        private func removeKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self)
        }
    }

