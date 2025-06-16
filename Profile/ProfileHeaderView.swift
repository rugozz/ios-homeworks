//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hipster cat"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileCat")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let setStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for something..."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    private let statusTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter new status"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textAlignment = .left
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var statusText: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    private func setupView() {
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)

        setupButtonAction()
        setupConstraints()
    }
    
    private func setupButtonAction() {
        setStatusButton.addTarget(self,
                                   action: #selector(buttonPressed),
                                   for: .touchUpInside)
        
        statusTextField.addTarget(self,
                                  action: #selector(statusTextChanged(_:)),
                                  for: .editingChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //Avatar Image
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            //Full Name
            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fullNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20),
            
            //Button
            setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 6),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            
            //Status
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 35),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 34),
            
            //Status TextField
            statusTextField.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    

    
    @objc private func buttonPressed() {
        statusLabel.text = statusText.isEmpty ? "No status" : statusText
        statusTextField.text = ""
        statusText = ""
        statusTextField.resignFirstResponder()
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
}
