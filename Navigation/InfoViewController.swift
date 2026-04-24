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
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadTodoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить Todo (JSONSerialization)", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadPlanetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить Планету (JSONDecoder)", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Информация"
        view.backgroundColor = .systemOrange
        
        view.addSubview(loadTodoButton)
        view.addSubview(loadPlanetButton)
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Кнопка Todo
            loadTodoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            loadTodoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadTodoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loadTodoButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка Planet
            loadPlanetButton.topAnchor.constraint(equalTo: loadTodoButton.bottomAnchor, constant: 10),
            loadPlanetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadPlanetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loadPlanetButton.heightAnchor.constraint(equalToConstant: 44),
            
            // UILabel для Todo (title)
            titleLabel.topAnchor.constraint(equalTo: loadPlanetButton.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // UILabel для Planet (orbital_period)
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orbitalPeriodLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Индикатор загрузки
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Начальное состояние
        titleLabel.text = "Нажмите зеленую кнопку для загрузки Todo"
        orbitalPeriodLabel.text = "Нажмите синюю кнопку для загрузки данных о планете"
    }
    
    private func setupActions() {
        loadTodoButton.addTarget(self, action: #selector(loadTodoData), for: .touchUpInside)
        loadPlanetButton.addTarget(self, action: #selector(loadPlanetData), for: .touchUpInside)
    }
    
    // MARK: - Реализация 1: Todo с JSONSerialization
    @objc private func loadTodoData() {
        activityIndicator.startAnimating()
        titleLabel.text = "Загрузка Todo..."
        titleLabel.textColor = .black
        
        // URL с любым номером (1-200)
        let randomID = Int.random(in: 1...200)
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(randomID)") else {
            updateTodoLabelWithError("Неверный URL")
            return
        }
        
        print("Загружаем Todo с URL: \(url)")
        
        // Запускаем URLSessionDataTask
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                guard let data = data, error == nil else {
                    self?.updateTodoLabelWithError("Ошибка загрузки")
                    return
                }
                
                // Парсим JSON с помощью JSONSerialization
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String: Any],
                       let title = dict["title"] as? String {
                        // Отображаем title в UILabel
                        self?.titleLabel.text = "📝 Todo title:\n\(title)"
                        self?.titleLabel.textColor = .black
                        print("Отображен title: \(title)")
                    } else {
                        self?.updateTodoLabelWithError("Не удалось получить title")
                    }
                } catch {
                    self?.updateTodoLabelWithError("Ошибка парсинга JSON")
                }
            }
        }.resume()
    }
    
    private func updateTodoLabelWithError(_ message: String) {
        titleLabel.text = "\(message)"
        titleLabel.textColor = .red
        print("\(message)")
    }
    
    // MARK: - Реализация 2: Planet с JSONDecoder
    @objc private func loadPlanetData() {
        activityIndicator.startAnimating()
        orbitalPeriodLabel.text = "Загрузка данных о планете..."
        orbitalPeriodLabel.textColor = .systemBlue
        
        // URL: https://swapi.dev/api/planets/1 (Татуин)
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else {
            updatePlanetLabelWithError("Неверный URL")
            return
        }
        
        print("Загружаем планету с URL: \(url)")
        
        // Запускаем URLSessionDataTask
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    self?.updatePlanetLabelWithError("Ошибка сети: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self?.updatePlanetLabelWithError("Нет данных")
                    return
                }
                
                // Парсим JSON с помощью JSONDecoder
                do {
                    let decoder = JSONDecoder()
                    let planet = try decoder.decode(Planet.self, from: data)
                    
                    // Отображаем orbital_period в UILabel
                    self?.orbitalPeriodLabel.text = "🪐 Планета: \(planet.name)\n\n🔄 Период обращения вокруг звезды: \(planet.orbitalPeriod) дней"
                    self?.orbitalPeriodLabel.textColor = .systemBlue
                    self?.orbitalPeriodLabel.font = .systemFont(ofSize: 16, weight: .semibold)
                    
                    print("Успешно загружена планета: \(planet.name)")
                    print("Орбитальный период: \(planet.orbitalPeriod) дней")
                    
                } catch {
                    print("Ошибка декодирования: \(error)")
                    self?.updatePlanetLabelWithError("Ошибка парсинга данных: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func updatePlanetLabelWithError(_ message: String) {
        orbitalPeriodLabel.text = "\(message)"
        orbitalPeriodLabel.textColor = .red
        print("\(message)")
    }
}

