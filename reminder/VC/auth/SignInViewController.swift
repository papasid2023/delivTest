//
//  SignInViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit

class SignInViewController: UIViewController {

    private let email = CustomTextField(authCustomTextFieldType: .email)
    private let password = CustomTextField(authCustomTextFieldType: .password)
    private let loginButton = CustomButton(authCustomButtonType: .login)
    private let registerLabel = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login page"
        hideKeyboard()
        setupUI()
       
    }
    
    private func setupUI(){
        view.addSubview(email)
        email.becomeFirstResponder()
        view.addSubview(password)
        view.addSubview(loginButton)
        view.addSubview(registerLabel)
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.clipsToBounds = true
        registerLabel.setTitle("Don't have account? Then sign up now", for: .normal)
        registerLabel.setTitleColor(.black, for: .normal)
        registerLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        registerLabel.addTarget(self, action: #selector(didTapRegisterLabel), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.midY - 200),
            email.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            email.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            email.heightAnchor.constraint(equalToConstant: 40),
            
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            password.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 90),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            registerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            registerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            
        ])
        
    }
    
    @objc func didTapRegisterLabel(){
            let vc = SignUpViewController()
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .formSheet
            self.present(navVc, animated: true)
            navVc.title = "Sign up page"
    }
    
    @objc func didTapLoginButton(){
        
        let LoginRequest = LoginRequest(email: email.text ?? "",
                                        password: password.text ?? "")
        
//        AuthManager.shared.login(with: LoginRequest) { error in
//            if let error {
//                return
//            } else {
//                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                    sceneDelegate.checkAuthentication()
//                }
//            }
//        }
        
        AuthManager.shared.login(with: LoginRequest) { error in
            if let error {
                print(error)
                return
            } else {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
    }


}
