//
//  AuthManager.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit
import FirebaseAuth

class AuthManager {
    
    public static let shared = AuthManager()
    
    public let auth = Auth.auth()
    
    init(){}
    
    public func register(with RegisterRequest: RegisterRequest, completion: @escaping (Error?)-> Void
    ){
        let email = RegisterRequest.email
        let password = RegisterRequest.password
        
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(error)
                print("Failed to register a new user \(email)")
                return
            } else {
                completion(nil)
                print("Success register a new user \(email)")
            }
        }
    }
    
    public func login(with LoginRequest: LoginRequest, completion: @escaping (Error?)-> Void
    ){
        
        let email = LoginRequest.email
        let password = LoginRequest.password
        
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                completion(error)
                print("Failed to login a new user \(email)")
                return
            } else {
                completion(nil)
                print("Success login a new user \(email)")
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?)-> Void){
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
}
