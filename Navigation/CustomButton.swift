//
//  CustomButton.swift
//  Navigation
//
//  Created by Лисин Никита on 10.12.2025.
//

import UIKit

class CustomButton: UIButton {
    
    private var action: (() -> Void)?
    
    init(title: String = "",
         titleColor: UIColor = .white,
         backgroundColor: UIColor = .systemBlue,
         cornerRadius: CGFloat = 10) {
        
        super.init(frame: .zero)
        
        setupButton(title: title,
                   titleColor: titleColor,
                   backgroundColor: backgroundColor,
                   cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String,
                            titleColor: UIColor,
                            backgroundColor: UIColor,
                            cornerRadius: CGFloat) {
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    @objc private func buttonTapped() {
        action?()
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
