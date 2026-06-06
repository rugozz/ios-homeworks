//
//  SavedPostsViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 26.04.2026.
//

import UIKit
import CoreData
import StorageService

class SavedPostsViewController: UIViewController {
    
    private var savedPosts: [NSManagedObject] = []
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .systemBackground
        setupTableView()
        loadSavedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedPosts()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadSavedPosts() {
        savedPosts = CoreDataManager.shared.fetchSavedPosts()
        tableView.reloadData()
    }
}

extension SavedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = savedPosts[indexPath.row]
        
        let title = post.value(forKey: "title") as? String ?? "Без названия"
        let createdAt = post.value(forKey: "createdAt") as? Date
        
        var config = cell.defaultContentConfiguration()
        config.text = title
        if let date = createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            config.secondaryText = "Сохранено: \(formatter.string(from: date))"
        }
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = savedPosts[indexPath.row]
            CoreDataManager.shared.deletePost(postToDelete as! SavedPostEntity)
            savedPosts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let savedPost = savedPosts[indexPath.row]
        let title = savedPost.value(forKey: "title") as? String ?? "Без названия"
        
        let post = Post(title: title)
        let postVC = PostViewController()
        postVC.post = post
        navigationController?.pushViewController(postVC, animated: true)
    }
}
