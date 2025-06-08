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
    
    private let enterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6
        return view
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
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
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(loginButton)
        contentView.addSubview(enterView)
        contentView.addSubview(enterView2)
        enterView.addSubview(loginTextField)
        enterView.addSubview(passwordTextField)


    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            setupKeyboardObservers()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            removeKeyboardObservers()
        }
        
        // MARK: - Actions
        
        @objc func willShowKeyboard(_ notification: NSNotification) {
            let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            scrollView.contentInset.bottom += keyboardHeight ?? 0.0
        }
        
        @objc func willHideKeyboard(_ notification: NSNotification) {
            scrollView.contentInset.bottom = 0.0
        }
    
    private func setupConstraints() {
        // Констрейнты для ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            
            // Поле логина
            loginTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Поле пароля
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            enterView.topAnchor.constraint(equalTo: loginTextField.topAnchor),
            enterView.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            enterView.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            enterView.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            
            enterView2.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            enterView2.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            enterView2.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            enterView2.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor),
            enterView2.heightAnchor.constraint(equalToConstant: 0.5),

            // Кнопка входа
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
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

