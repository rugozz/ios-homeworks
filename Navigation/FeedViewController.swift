//
//  FeedViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 20.05.2025.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let demoPost = Post(title: "Мой первый пост")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
    
    }
    
    private func setupView () {
        view.backgroundColor = .systemBackground
        
        let showPostButton = UIButton(type: .system)
        showPostButton.setTitle("Показать пост", for: .normal)
        showPostButton.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        
        showPostButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(showPostButton)
        
        NSLayoutConstraint.activate([
            showPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showPostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
