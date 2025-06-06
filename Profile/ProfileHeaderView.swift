//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hipster cat"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileCat")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let showStatusButton: UIButton = {
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
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    private func setupView() {
        
        addSubview(profileImage)
        addSubview(titleLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(showStatusButton)

        setupButtonAction()
        setupConstraints()
    }
    
    private func setupButtonAction() {
        showStatusButton.addTarget(self,
                                   action: #selector(buttonPressed),
                                   for: .touchUpInside)
        
        statusTextField.addTarget(self,
                                  action: #selector(statusTextChanged(_:)),
                                  for: .editingChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //Profile Image
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            
            //Title
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20),
            
            //Button
            showStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            showStatusButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 26),
            showStatusButton.heightAnchor.constraint(equalToConstant: 50),
            
            //Status
            statusLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 35),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: showStatusButton.topAnchor, constant: -34),
            
            //Status TextField
            statusTextField.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusTextField.bottomAnchor.constraint(equalTo: showStatusButton.topAnchor),
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
