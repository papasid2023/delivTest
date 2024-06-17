//
//  CustomTextField.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    enum authCustomTextField {
        case username
        case email
        case password
    }
    
    private let authCustomTextFieldType: authCustomTextField
    
    init(authCustomTextFieldType: authCustomTextField) {
        self.authCustomTextFieldType = authCustomTextFieldType
        super.init(frame: .zero)
        backgroundColor = .secondarySystemFill
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 15
        autocapitalizationType = .none
        autocorrectionType = .no
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        leftViewMode = .always
        
        
        switch authCustomTextFieldType {
        case .username:
            placeholder = "Enter your name"
        case .email:
            placeholder = "Your email"
            keyboardType = .emailAddress
        case .password:
            placeholder = "Password"
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
