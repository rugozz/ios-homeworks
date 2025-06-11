//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Properties
    
    private let posts: [Post2] = [
        Post2(
            author: "Travaler_55672",
            description: "Удивительный закат на Пхукете! От путешествия я получаю незабываемые эмоции!",
            image: "phuket",
            likes: 367,
            views: 1589
        ),
        
        Post2(
            author: "IOS-Developer_1128",
            description: "Новый МакБук - невероятный!",
            image: "macbook",
            likes: 155,
            views: 649
        ),
        
        Post2(
            author: "I_Love_Eat",
            description: "Домашняя пицца с моцареллой и базиликом. Рецепт в комментариях! 🍕",
            image: "pizza",
            likes: 267,
            views: 989
        ),
        
        Post2(
            author: "Fitness_Coach",
            description: "Утренняя пробежка — лучший способ начать день!",
            image: "run",
            likes: 347,
            views: 1459
        ),
    ]

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - UITableViewDatasource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath)
                as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return ProfileHeaderView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return 220
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
