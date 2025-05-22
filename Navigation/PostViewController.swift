//
//  PostViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 21.05.2025.
//

import UIKit

class PostViewController: UIViewController {

    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard post != nil else {
            fatalError("Post must be set before showing this view controller")
                }
        setupView()
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
        
    }
    


       

