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
    
    // Фабрика для создания UserService
    private var userService: UserService {
        #if DEBUG
        // В Debug схеме используем TestUserService
        return TestUserService()
        #else
        // В Release схеме используем CurrentUserService
        let releaseUser = User(
            login: "admin",
            fullName: "Иван Иванов",
            avatar: UIImage(named: "avatar_placeholder") ?? UIImage(systemName: "person.circle.fill"),
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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
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
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        configureLoginButton()
        setupTextFieldDelegates()
        
        // Отладочная информация
        #if DEBUG
        print("LogInViewController: Загружен в режиме DEBUG")
        #else
        print("LogInViewController: Загружен в режиме RELEASE")
        #endif
    }
    
    // MARK: - Setup
    
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
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
    }
    
    private func setupTextFieldDelegates() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        // Добавляем кнопку "Done" для закрытия клавиатуры
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        
        loginTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureLoginButton() {
        guard let normalImage = UIImage(named: "blue_pixel") else {
            print("Warning: Изображение blue_pixel не найдено")
            // Устанавливаем цвет фона как fallback
            loginButton.backgroundColor = .systemBlue
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        loginButton.setBackgroundImage(resizableHighlighted, for: .selected)
        loginButton.setBackgroundImage(resizableHighlighted, for: .disabled)

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        guard let login = loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !login.isEmpty else {
            showAlert(message: "Введите логин")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Введите пароль")
            return
        }
        
        // Валидация длины пароля
        if password.count < 3 {
            showAlert(message: "Пароль должен содержать не менее 3 символов")
            return
        }
        
        guard let delegate = loginDelegate else {
            showAlert(message: "Ошибка инициализации системы авторизации")
            return
        }
        
        // Отображаем индикатор загрузки
        loginButton.isEnabled = false
        loginButton.alpha = 0.7
        
        // Проверяем логин и пароль через делегата
        let isValidCredentials = delegate.check(login: login, password: password)
        
        // Имитируем задержку для UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1.0
            
            if isValidCredentials {
                self.handleSuccessfulLogin(login: login)
            } else {
                self.showAlert(message: "Неверный логин или пароль")
            }
        }
    }
    
    private func handleSuccessfulLogin(login: String) {
        // Получаем информацию о пользователе через UserService
        if let user = userService.getUser(by: login) {
            // Успешная авторизация - переходим на экран профиля
            let profileVC = ProfileViewController()
            profileVC.user = user
            
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
            // Пользователь не найден в системе (хотя логин/пароль верные)
            #if DEBUG
            showAlert(message: "DEBUG: Пользователь найден, но не получен из UserService")
            #else
            showAlert(message: "Ошибка получения данных пользователя")
            #endif
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Внимание",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    @objc private func willShowKeyboard(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.verticalScrollIndicatorInsets = contentInsets
        
        // Прокручиваем к активному полю ввода
        if let activeTextField = findActiveTextField() {
            let rect = activeTextField.convert(activeTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    private func findActiveTextField() -> UITextField? {
        if loginTextField.isFirstResponder {
            return loginTextField
        } else if passwordTextField.isFirstResponder {
            return passwordTextField
        }
        return nil
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Constraints
    
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
        
        // Констрейнты для элементов
        NSLayoutConstraint.activate([
            // Логотип
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // StackView с полями ввода
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            
            // Разделитель между полями
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
    
    // MARK: - Cleanup
    
    deinit {
        removeKeyboardObservers()
    }
}

// MARK: - Login Info Extension

extension LogInViewController {
    func setLoginCredentials(login: String, password: String) {
        loginTextField.text = login
        passwordTextField.text = password
    }
}
