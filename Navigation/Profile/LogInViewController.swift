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
    
    private var userService: UserService {
        #if DEBUG
        return TestUserService()
        #else
        let releaseUser = User(
            login: "admin",
            fullName: "Иван Иванов",
            avatar: UIImage(named: "avatar_placeholder") ?? UIImage(systemName: "person.circle.fill"),
            status: "В сети"
        )
        return CurrentUserService(user: releaseUser)
        #endif
    }
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
        textField.placeholder = "Email"
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    // Кнопка входа
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка регистрации
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // StackView для кнопок (горизонтальный)
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.clipsToBounds = true
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        setupConstraints()
        configureButtons()
        setupTextFieldDelegates()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginTextField.layer.cornerRadius = 10
        loginTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    // MARK: - Setup
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(buttonsStackView)
        
        // Добавляем кнопки в горизонтальный StackView
        buttonsStackView.addArrangedSubview(loginButton)
        buttonsStackView.addArrangedSubview(signUpButton)
        
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(passwordTextField)
        
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupTextFieldDelegates() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        // Добавляем отслеживание изменений для кнопок
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureButtons() {
        // Настройка кнопки входа
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // Настройка кнопки регистрации
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        // Начальное состояние кнопок
        updateButtonsState()
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let email = loginTextField.text, !email.isEmpty else {
            showAlert(message: "Введите email")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Введите пароль")
            return
        }
        
        guard let delegate = loginDelegate else {
            showAlert(message: "Ошибка инициализации системы авторизации")
            return
        }
        
        // Блокируем кнопки во время запроса
        setButtonsEnabled(false)
        
        // Вызываем проверку через делегат (LoginInspector)
        delegate.checkCredentials(email: email, password: password)
    }
    
    @objc private func signUpButtonTapped() {
        guard let email = loginTextField.text, !email.isEmpty else {
            showAlert(message: "Введите email")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Введите пароль")
            return
        }
        
        // Валидация пароля
        guard password.count >= 6 else {
            showAlert(message: "Пароль должен содержать минимум 6 символов")
            return
        }
        
        guard let delegate = loginDelegate else {
            showAlert(message: "Ошибка инициализации системы авторизации")
            return
        }
        
        // Блокируем кнопки во время запроса
        setButtonsEnabled(false)
        
        // Вызываем регистрацию через делегат
        delegate.signUp(email: email, password: password)
    }
    
    // Метод для успешного входа/регистрации
    func handleSuccessfulLogin(login: String) {
        // Разблокируем кнопки
        setButtonsEnabled(true)
        
        // Получаем информацию о пользователе для отладки
        #if DEBUG
        print("DEBUG: Используется TestUserService")
        if let user = userService.getUser(by: login) {
            print("Пользователь: \(user.fullName)")
        }
        #else
        print("RELEASE: Используется CurrentUserService")
        #endif
        
        // Создаем ViewModel для ProfileViewController
        let profileViewModel = ProfileViewModel(userService: userService, login: login)
        
        // Создаем ProfileViewController с ViewModel
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        
        // Обновляем TabBar для показа профиля
        if let tabBarController = self.tabBarController,
           let navController = tabBarController.viewControllers?[1] as? UINavigationController {
            // Заменяем текущий view controller на ProfileViewController
            navController.setViewControllers([profileVC], animated: true)
            profileVC.navigationItem.hidesBackButton = true
            // Показываем TabBar
            profileVC.hidesBottomBarWhenPushed = false
        } else {
            // Fallback если не в TabBar
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc private func textFieldDidChange() {
        updateButtonsState()
    }
    
    private func updateButtonsState() {
        let isEmailEmpty = loginTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true
        let isValid = !isEmailEmpty && !isPasswordEmpty
        
        loginButton.isEnabled = isValid
        loginButton.alpha = isValid ? 1.0 : 0.5
        
        signUpButton.isEnabled = isValid
        signUpButton.alpha = isValid ? 1.0 : 0.5
    }
    
    private func setButtonsEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        signUpButton.isEnabled = enabled
        loginButton.alpha = enabled ? 1.0 : 0.5
        signUpButton.alpha = enabled ? 1.0 : 0.5
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Внимание",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Разблокируем кнопки после закрытия алерта
            self?.setButtonsEnabled(true)
        })
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling
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
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).priority(.defaultHigh)
        ])

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 100.5)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Priority Helper
extension NSLayoutConstraint {
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

// MARK: - Login Info Extension
extension LogInViewController {
    func setLoginCredentials(login: String, password: String) {
        loginTextField.text = login
        passwordTextField.text = password
        updateButtonsState()
    }
}
