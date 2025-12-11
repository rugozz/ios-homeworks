//
//  FeedViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 20.05.2025.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    private let demoPost = Post(title: "Мой первый пост")
    private let feedModel = FeedModel()
    
    // UI элементы
    private let wordTextField = UITextField()
    private let checkButton = CustomButton(
        title: "Проверить",
        titleColor: .white,
        backgroundColor: .systemBlue,
        cornerRadius: 10
    )
    private let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupFeedModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Лента"
        
        // Настройка текстового поля
        wordTextField.placeholder = "Введите слово"
        wordTextField.borderStyle = .roundedRect
        wordTextField.autocapitalizationType = .none
        wordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка лейбла результата
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Старые кнопки
        let button1 = UIButton(type: .system)
        button1.setTitle("Кнопка 1", for: .normal)
        button1.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("Кнопка 2", for: .normal)
        button2.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        
        // StackView для старого контента
        let oldButtonsStack = UIStackView(arrangedSubviews: [button1, button2])
        oldButtonsStack.axis = .vertical
        oldButtonsStack.spacing = 10
        oldButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Главный StackView
        let mainStack = UIStackView(arrangedSubviews: [wordTextField, checkButton, resultLabel, oldButtonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            wordTextField.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            wordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            checkButton.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            checkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        checkButton.setAction { [weak self] in
            guard let word = self?.wordTextField.text else { return }
            self?.feedModel.check(word: word)
        }
    }
    
    private func setupFeedModel() {
        feedModel.onWordCheckResult = { [weak self] isCorrect, message in
            DispatchQueue.main.async {
                self?.resultLabel.text = message
                self?.resultLabel.textColor = isCorrect ? .systemGreen : .systemRed
                
                if isCorrect {
                    self?.wordTextField.isEnabled = false
                    self?.checkButton.isEnabled = false
                }
            }
        }
    }
    
    @objc private func showPost() {
        let postVC = PostViewController()
        postVC.post = demoPost
        navigationController?.pushViewController(postVC, animated: true)
    }
}
