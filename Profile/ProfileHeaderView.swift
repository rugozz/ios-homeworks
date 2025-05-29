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
    private let showStatusButton = UIButton(type: .system)
    
    private func setupButton() {
        
        showStatusButton.setTitle("Show status", for: .normal)
        showStatusButton.setTitleColor(.white, for: .normal)
        showStatusButton.layer.cornerRadius = 4
        showStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        showStatusButton.layer.shadowRadius = 4
        showStatusButton.layer.shadowColor = UIColor.black.cgColor
        showStatusButton.layer.shadowOpacity = 0.7
        showStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        showStatusButton.backgroundColor = .systemBlue
        showStatusButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private let status: UILabel = {
        let label = UILabel()
        label.text = "Waiting for something..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    
    
    private var currentStatus: String = "Мой текущий статус"
    
    @objc private func buttonPressed() {
        print("Текущий статус:", currentStatus)
    }
    
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
        
        addSubview(status)
        addSubview(profileImage)
        addSubview(titleLabel)
        addSubview(showStatusButton)

        setupButton()
        
        setupConstraints()
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
            
            showStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            showStatusButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            showStatusButton.heightAnchor.constraint(equalToConstant: 50),
            //Status
            status.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            status.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            status.bottomAnchor.constraint(equalTo: showStatusButton.topAnchor, constant: -34)
            
        ])
    }
}
