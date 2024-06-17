//
//  CustomButton.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit

class CustomButton: UIButton {
    
    enum authCustomButton {
        case register
        case login
    }
    
    private let authCustomButtonType: authCustomButton
    
    init(authCustomButtonType: authCustomButton) {
        self.authCustomButtonType = authCustomButtonType
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .blue
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .black
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        switch authCustomButtonType {
        case .register:
            setTitle("Register", for: .normal)
        case .login:
            setTitle("Login", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
