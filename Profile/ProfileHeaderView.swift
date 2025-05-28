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

    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileCat")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    
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
        
        setupConstraints()
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Картинка (отступ слева 16pt, отступ сверху 16pt от title)
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            
            // Заголовок (отступ от картинки 16pt)
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
}
