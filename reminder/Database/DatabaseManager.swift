//
//  DatabaseManager.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseFirestore

class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    public let database = Firestore.firestore()
    
    init(){}
    
    
    //MARK: insert new user
    public func insertNewUser(user: user, completion: @escaping (Bool)-> Void
    ){
        let documentId = user.email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let data = [
            "email": user.email,
            "username": user.username,
            "password": user.password,
        ]
        
        database.collection("users").document(documentId).setData(data) { error in
            if let error {
                print(error)
                return
            } else {
                print("data of new user \(user.email) success download in database users")
            }
        }
    }
    
    
    //MARK: update avatar
    public func updateAvatar(email: String,
                             completion: @escaping (Bool)-> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let avatarRef = "usersAvatars/\(path)/avatar.jpeg"
        
        let dbRef = database.collection("users").document(path)
        
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["avatar"] = avatarRef
            
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
    
    //MARK: get user data
    public func getUser(email: String,
                        completion: @escaping (user?) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let username = data["username"],
                      let password = data["password"],
                      error == nil else {
                    return
                }
                
                let avatarRef = data["avatar"]
                
                let user = user(username: username, email: email, password: password, avatar: avatarRef)
                completion(user)
            }
    }
    
    //MARK: insert full zero preOrder data in db for future changes
    public func insertPreOrderData(email: String,
                                   productId: String,
                                   productPreOrderData: productPreOrderData,
                                   completion: @escaping (Bool) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let chorizzoData: [String : Any] = [
            "productId": "chorizzo",
            "name": "chorizzo",
            "price": 500,
            "counter": 0,
            "image": "pizza",
            "description": "This chorizo pizza is an incredible homemade pizza recipe that's got a little bit of spice, some savory goodness, and a tangy kick."
        ]
        
        let FourCheesezData: [String : Any] = [
            "productId": "FourCheesez",
            "name": "4 cheesez",
            "price": 1000,
            "counter": 0,
            "image": "pizza2",
            "description": " If you're looking for an ultra cheesy pizza then look no further than this classic! So rich and delicious you'll never have another pizza night without it!"
        ]
        
        let PiggyData: [String : Any] = [
            "productId": "Piggy",
            "name": "Piggy",
            "price": 750,
            "counter": 0,
            "image": "pig",
            "description": "This recipe for Piggy Pizza is the Ultimate Meat Pizza, full of delicious meaty goodness that will have you pigging out! Don’t snort! It’s true! You have your delightful pepperoni, crispy bacon, spicy chorizo and sweet ham. Don’t forget there’s loads of cheese too."
        ]
        
        let ParmPorkData: [String : Any] = [
            "productId": "ParmPork",
            "name": "ParmPork",
            "price": 1200,
            "counter": 0,
            "image": "pork",
            "description": "Then, however, when I pulled it out of the oven, I looked at it and … instantly I realized that I’d just made Chicken Parmesan, but … with Pork. I didn’t mean to, but when I was done, it was undeniable. I needed me some Squaghetti! Having none lying around, I decided to go back to the pizza idea and pretend that was my plan, all along."
        ]
        
        
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("chorizzo")
            .setData(chorizzoData) { error in
                if let error {
                    print(error)
                    return
                } else {
                    print("Success upload preOrderData of user \(email) in db")
                    completion(error == nil)
                }
            }
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("FourCheesez")
            .setData(FourCheesezData) { error in
                if let error {
                    print(error)
                    return
                } else {
                    completion(error == nil)
                }
            }
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("Piggy")
            .setData(PiggyData) { error in
                if let error {
                    print(error)
                    return
                } else {
                    completion(error == nil)
                }
            }
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("ParmPork")
            .setData(ParmPorkData) { error in
                if let error {
                    print(error)
                    return
                } else {
                    completion(error == nil)
                }
            }
        
    }
    
    //MARK: update order
    func updateOrder(email: String,
                     orderData: productPreOrderData,
                     completion: @escaping (Bool) -> Void
    ) {
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document(orderData.productId)
            .updateData([
                "counter": orderData.counter
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    
    //MARK: update counter
    public func updateCounter(email: String,
                              productName: String,
                              updateInt: Int,
                              completion: @escaping (Bool)-> Void
    ){
        
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document(productName)
            .updateData(["counter" : updateInt]) { error in
                if let error {
                    print(error)
                    return
                } else {
                    completion(error == nil)
                }
            }
        
    }
    
    //MARK: decrease counter
    public func decreaseCounter(email: String,
                              productName: String,
                              updateInt: Int,
                              completion: @escaping (Bool)-> Void
    ){
        
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document(productName)
            .updateData(["counter" : updateInt]) { error in
                if let error {
                    print(error)
                    return
                } else {
                    completion(error == nil)
                }
            }
        
    }
    
    //MARK: get preOrder data from db
    public func getPreOrderData(email: String,
                                completion: @escaping ([productPreOrderData])-> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .getDocuments { snapshot , error in
                
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                
                let orders: [productPreOrderData] = documents.compactMap({ dictionary in
                    guard let productId = dictionary["productId"] as? String,
                          let name = dictionary["name"] as? String,
                          let price = dictionary["price"] as? Int,
                          let counter = dictionary["counter"] as? Int,
                          let image = dictionary["image"] as? String,
                          let description = dictionary["description"] as? String else {
                        print("Invalid proOrder fetch conversion")
                        return nil
                    }
                    
                    guard counter != 0 else {
                        return nil
                    }
                    
                    let order = productPreOrderData(productId: productId, name: name, price: price, counter: counter, image: image, description: description)
                    
                    return order
                })
                completion(orders)
            }
    }
    
    //MARK: get all products data
    public func getAllProductsData(email: String,
                                completion: @escaping ([productPreOrderData])-> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .getDocuments { snapshot , error in
                
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                
                let orders: [productPreOrderData] = documents.compactMap({ dictionary in
                    guard let productId = dictionary["productId"] as? String,
                          let name = dictionary["name"] as? String,
                          let priceButton = dictionary["price"] as? Int,
                          let counter = dictionary["counter"] as? Int,
                          let image = dictionary["image"] as? String,
                          let description = dictionary["description"] as? String else {
                        print("Invalid proOrder fetch conversion")
                        return nil
                    }
                    
                    let order = productPreOrderData(productId: productId, name: name, price: priceButton, counter: counter, image: image, description: description)
                    
                    return order
                })
                completion(orders)
            }
    }
    
    //MARK: get counters
    public func getCounters(email: String,
                            completion: @escaping ([Int])-> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .getDocuments { snapshot , error in
                
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                
                let counters: [Int] = documents.compactMap({ dictionary in
                    guard let counter = dictionary["counter"] as? Int else {
                        print("Invalid counter fetch conversion")
                        return 0
                    }
                    return counter
                })
                completion(counters)
            }
    }
    
    //MARK: get counter of Four Cheesez
    public func getCounterOfFourCheesez(email: String,
                                     completion: @escaping (Int) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("FourCheesez")
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let neededCounter = data["counter"] as? Int,
                      error == nil else {
                    return
                }
                completion(neededCounter)
            }
    }
    
    //MARK: get counter of Parm Pork
    public func getCounterOfParmPork(email: String,
                                     completion: @escaping (Int) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("ParmPork")
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let neededCounter = data["counter"] as? Int,
                      error == nil else {
                    return
                }
                completion(neededCounter)
            }
    }
    
    //MARK: get counter of Piggy
    public func getCounterOfPiggy(email: String,
                                     completion: @escaping (Int) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("Piggy")
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let neededCounter = data["counter"] as? Int,
                      error == nil else {
                    return
                }
                completion(neededCounter)
            }
    }
    
    //MARK: get counter of Chorizzo
    public func getCounterOfChorizzo(email: String,
                                     completion: @escaping (Int) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        database
            .collection("preOrders")
            .document(documentId)
            .collection("bucket")
            .document("chorizzo")
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let neededCounter = data["counter"] as? Int,
                      error == nil else {
                    return
                }
                completion(neededCounter)
            }
    }
}
