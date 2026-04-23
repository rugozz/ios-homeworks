//
//  InfoViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 22.05.2025.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить данные", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Информация"
        view.backgroundColor = .systemOrange
        view.addSubview(titleLabel)
        view.addSubview(loadButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
    }
    
    private func setupButton() {
        loadButton.addTarget(self, action: #selector(loadData), for: .touchUpInside)
    }
    
    // MARK: - Network Logic
    @objc private func loadData() {
        // URL с любым номером (1-200)
        let randomID = Int.random(in: 1...200)
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(randomID)") else { return }
        
        // Запускаем URLSessionDataTask
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self?.titleLabel.text = "Ошибка загрузки"
                    return
                }
                
                // Парсим JSON с помощью JSONSerialization
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String: Any],
                       let title = dict["title"] as? String {
                        // Отображаем title в UILabel
                        self?.titleLabel.text = title
                    } else {
                        self?.titleLabel.text = "Не удалось получить title"
                    }
                } catch {
                    self?.titleLabel.text = "Ошибка парсинга"
                }
            }
        }.resume()
    }
}


