//
//  SignUpViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let username = CustomTextField(authCustomTextFieldType: .username)
    private let email = CustomTextField(authCustomTextFieldType: .email)
    private let password = CustomTextField(authCustomTextFieldType: .password)
    private let registerButton = CustomButton(authCustomButtonType: .register)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Register page"
        hideKeyboard()
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(username)
        username.becomeFirstResponder()
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            username.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.midY - 200),
            username.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            username.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            username.heightAnchor.constraint(equalToConstant: 40),
            
            email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 10),
            email.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            email.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            email.heightAnchor.constraint(equalToConstant: 40),
            
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            password.heightAnchor.constraint(equalToConstant: 40),
            
            registerButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    @objc func didTapRegisterButton(){
        
        let RegisterRequest = RegisterRequest(email: email.text ?? "",
                                              password: password.text ?? "")
        
        //auth
        AuthManager.shared.register(with: RegisterRequest) { error in
            if let error {
                print(error)
                return
            } else {
                
                let newUser = user(username: self.username.text ?? "",
                                   email: self.email.text ?? "",
                                   password: self.password.text ?? "",
                                   avatar: nil)
                //add new user data in db
                DatabaseManager.shared.insertNewUser(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(RegisterRequest.email, forKey: "email")
                }
                
                let email = self.email.text ?? ""
                
                let productPreOrderData = productPreOrderData(productId: "2",
                                                              name: "Chorizzo",
                                                              price: 500,
                                                              counter: 0,
                                                              image: "pizza",
                                                              description: "")
                
                //add preorderData in db
                DatabaseManager.shared.insertPreOrderData(email: email, productId: "ChorizzoPath",
                                                          productPreOrderData: productPreOrderData) { error in
                    if error {
                        return
                    }
                }
                
                //goToController
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
    }
    
}
