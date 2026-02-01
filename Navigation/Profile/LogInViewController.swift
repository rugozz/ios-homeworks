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
        textField.placeholder = "Email or Phone"
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
    
    // Используем CustomButton вместо UIButton
    private let loginButton: UIButton = {
        let button = CustomButton(
            title: "Log In",
            titleColor: .white,
            backgroundColor: .systemBlue,
            cornerRadius: 10
        )
        return button
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
        configureLoginButton()
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
        contentView.addSubview(loginButton)

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
    }
    
    private func configureLoginButton() {
        // Устанавливаем действие через CustomButton
        if let customButton = loginButton as? CustomButton {
            customButton.setAction { [weak self] in
                self?.loginButtonTapped()
            }
        } else {
            // Fallback на стандартный UIButton
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
        
        // Настраиваем фоновое изображение
        if let normalImage = UIImage(named: "blue_pixel") {
            let resizableNormal = normalImage.resizableImage(
                withCapInsets: UIEdgeInsets.zero,
                resizingMode: .stretch
            )
            
            let resizableHighlighted = normalImage.withAlpha(0.8)?.resizableImage(
                withCapInsets: UIEdgeInsets.zero,
                resizingMode: .stretch
            )
            
            loginButton.setBackgroundImage(resizableNormal, for: .normal)
            loginButton.setBackgroundImage(resizableHighlighted, for: .highlighted)
        } else {
            loginButton.backgroundColor = .systemBlue
        }
    }
    
    // MARK: - Actions
    private func handleSuccessfulLogin(login: String) {
        // Создаем ViewModel через фабрику
        let viewModel = ProfileViewModelFactory.createProfileViewModel(for: login)
        
        // Создаем ProfileViewController с ViewModel
        let profileVC = ProfileViewController(viewModel: viewModel)
        
        // Добавляем информацию о типе сервиса для отладки
        #if DEBUG
        print("DEBUG: Используется TestUserService")

        if let user = userService.getUser(by: login) {
            print("Пользователь: \(user.fullName)")
        }
        #else
        print("RELEASE: Используется CurrentUserService")
        #endif
        
        navigationController?.pushViewController(profileVC, animated: true)
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
            showAlert(message: "Ошибка инициализации системы авторизации")
            return
        }
        
        let isValidCredentials = delegate.check(login: login, password: password)
        
        if isValidCredentials {
            handleSuccessfulLogin(login: login)
        } else {
            showAlert(message: "Неверный логин или пароль")
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
            stackView.heightAnchor.constraint(equalToConstant: 100.5) // 50 + 0.5 + 50
        ])

        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
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
    }
}
