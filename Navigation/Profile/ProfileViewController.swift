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
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
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
        title = "Профиль"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UITableViewDatasource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return posts.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotosTableViewCell.identifier,
                for: indexPath
            ) as! PhotosTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTableViewCell.identifier,
                for: indexPath
            ) as! PostTableViewCell
            cell.configure(with: posts[indexPath.row])
            cell.selectionStyle = .none
            return cell
            
        default:
            fatalError("Unexpected section index")
        }
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
        switch indexPath.section {
        case 0: return 160
        case 1: return UITableView.automaticDimension
        default: return 0
        }
    }
        
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        case 1: return 400
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PhotosTableViewCellDelegate
extension ProfileViewController: PhotosTableViewCellDelegate {
    func photosTableViewCellDidTap(_ cell: PhotosTableViewCell) {
        let galleryVC = PhotoViewController()
        navigationController?.pushViewController(galleryVC, animated: true)
    }

}
