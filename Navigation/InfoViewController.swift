//
//  InfoViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 22.05.2025.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButton()

    }
    
    private func setupView() {
        title = "Информация"
        view.backgroundColor = .systemOrange

    }
    
    private func setupButton() {
        let button = UIButton(type: .system)
        button.setTitle("Показать предупреждение", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func showAlert() {
        let alert = UIAlertController(
            title: "Внимание!", message: "Вы уверены?", preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            print("Пользователь нажал 'да'")
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            print("Пользователь нажал 'нет'")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
}
