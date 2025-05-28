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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileHeaderView.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .lightGray
        title = "Profile"
        
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
}
