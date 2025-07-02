//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit
import SnapKit

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
        setStatusButton.addTarget(self,
                                   action: #selector(buttonPressed),
                                   for: .touchUpInside)
        
        statusTextField.addTarget(self,
                                  action: #selector(statusTextChanged(_:)),
                                  for: .editingChanged)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(27)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(35)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(34)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        setStatusButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(statusTextField.snp.bottom).offset(6)
            make.height.equalTo(50)
        }
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
