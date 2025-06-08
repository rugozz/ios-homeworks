//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let profileHeaderView = ProfileHeaderView()
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .white
        
        profileHeaderView.backgroundColor = .lightGray
        title = "Profile"
        
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.setTitle("Просто КНОПКА", for: .normal)
        actionButton.backgroundColor = .systemCyan
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.layer.cornerRadius = 8
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
