//
//  PostViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 21.05.2025.
//

import UIKit
import StorageService

class PostViewController: UIViewController {

    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard post != nil else {
            fatalError("Post not set")
                }
        setupView()
        setupNavigationBar()
        }
    
    private func setupView() {
        title = post.title
        
        view.backgroundColor = .systemTeal
        
        let label = UILabel()
        label.text = "Содержимое поста: \(post.title)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showInfo))
    }
    
    @objc private func showInfo() {
        let infoVC = InfoViewController()
        let navController = UINavigationController(rootViewController: infoVC)
        present(navController, animated: true)
    }
}
    


       

