//
//  PostViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 21.05.2025.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

       
    }

    private func setupView() {
        title = "Детали поста"
        
        view.backgroundColor = .systemTeal
        
        let label = UILabel()
        label.text = "Содержимое поста"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
