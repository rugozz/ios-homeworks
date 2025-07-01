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
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
    
    }
    
    private func setupView () {
        view.backgroundColor = .systemBackground
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let firstButton = createButton(title: "Кнопка 1")
        let secondButton = createButton(title: "Кнопка 2")
        
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        
        // Констрейнты для StackView
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        

    }
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        return button
    }
    
    private func setupNavigation() {
        title = "Лента"
    }
    
    @objc private func showPost() {
        let postVC = PostViewController()
        postVC.post = demoPost
    
        navigationController?.pushViewController(postVC, animated: true)
        
    }

}
