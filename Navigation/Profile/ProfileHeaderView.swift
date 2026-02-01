//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func didTapAvatar(_ avatarImageView: UIImageView)
}

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
    
    // Заменяем UIButton на CustomButton
    private let setStatusButton = CustomButton(
        title: "Show status",
        titleColor: .white,
        backgroundColor: .systemBlue,
        cornerRadius: 4
    )
    
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
    
    weak var delegate: ProfileHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        
        // Добавляем тень для кнопки после layout
        setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOpacity = 0.7
    }
    
    private func setupView() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)

        setupButtonAction()
        setupConstraints()
        setupAvatarTap()
    }
    
    private func setupAvatarTap() {
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc private func avatarTapped() {
        delegate?.didTapAvatar(avatarImageView)
    }
    
    private func setupButtonAction() {
        // Устанавливаем действие для CustomButton
        setStatusButton.setAction { [weak self] in
            self?.buttonPressed()
        }
        
        statusTextField.addTarget(self,
                                  action: #selector(statusTextChanged(_:)),
                                  for: .editingChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Avatar Image
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
    
    private func setupGestureRecognizers() {
        avatarImageView.isUserInteractionEnabled = true
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(avatarTap)
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

extension ProfileHeaderView {
    func configure(with user: User) {
        fullNameLabel.text = user.fullName
        statusLabel.text = user.status
        avatarImageView.image = user.avatar ?? UIImage(systemName: "person.circle.fill")
    }
}
