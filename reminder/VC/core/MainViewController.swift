//
//  MainViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit
import Foundation
import FirebaseAuth

class MainViewController: UIViewController {

    private let currentEmail = Auth.auth().currentUser?.email ?? ""
    
    private let firstMealImage = UIImageView()
    private let firstMealTitle = UILabel()
    private let firstMealText = UILabel()
    private let firstMealPrice = UILabel()
    
    private let secondMealImage = UIImageView()
    private let secondMealTitle = UILabel()
    private let secondMealText = UILabel()
    private let secondMealPrice = UILabel()
    
    private let orderButton = UIButton()
    private let secondOrderButton = UIButton()
    private let bucket = UIButton()
    
    private let downImage = UIImageView()
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
//    let notificationGenerator = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Choose your meal"
        setupFirstPizza()
        setupSecondPizza()
        setupUI()
        fetchCounters()
        getCounterOf_Chorizzo()
        getCounterOf_FourCheesez()
        fetchPreOrderData()
        
        view.addSubview(downImage)
        downImage.image = .pizza
        downImage.clipsToBounds = true
        downImage.layer.cornerRadius = 15
        downImage.frame = CGRect(x: Int(view.frame.width - 140), y: Int(view.frame.height) - 250, width: 50, height: 50)
        downImage.layer.opacity = 0
    
    }
    
    public var orders: [productPreOrderData] = []
    
    
    private func fetchPreOrderData(){
        print("fetching ordersData")
        DatabaseManager.shared.getPreOrderData(email: currentEmail) { [weak self] orders in
            self?.orders = orders
            print("orders found \(orders.count)")
            
            var sumOfAllOrders: Int = 0
            
            for order in orders {
                let sum = order.price * order.counter
                sumOfAllOrders += sum
            }
            
            DispatchQueue.main.async {
                self?.bucket.setTitle(String(sumOfAllOrders), for: .normal)
            }
        }
    }
    
    func animateChirzzo(){
        downImage.layer.opacity = 1
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [downImage])
        gravity.gravityDirection = .init(dx: 0, dy: 1)
        animator.addBehavior(gravity)
        
    }
    
    
    
    private func setupFirstPizza(){
        view.addSubview(firstMealImage)
        view.addSubview(firstMealTitle)
        view.addSubview(firstMealText)
        view.addSubview(firstMealPrice)
        
        
        firstMealImage.image = UIImage.pizza
        firstMealImage.contentMode = .scaleAspectFill
        firstMealImage.clipsToBounds = true
        firstMealImage.layer.cornerRadius = 20
        
        firstMealTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        firstMealTitle.text = "Chorizzo"
        
        firstMealText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        firstMealText.text = "Get best pizza with 4 kinds of cheese"
        firstMealText.numberOfLines = 0
        firstMealText.lineBreakMode = .byWordWrapping
        firstMealText.textColor = .darkGray
        
        firstMealPrice.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        firstMealPrice.text = "500 руб."
        
    }
    
    private func setupSecondPizza(){
        view.addSubview(secondMealImage)
        view.addSubview(secondMealTitle)
        view.addSubview(secondMealText)
        view.addSubview(secondMealPrice)
        
        
       secondMealImage.image = UIImage.pizza2
       secondMealImage.contentMode = .scaleAspectFill
       secondMealImage.clipsToBounds = true
       secondMealImage.layer.cornerRadius = 20
    
       secondMealTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
       secondMealTitle.text = "FourCheesez"
       
       secondMealText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
       secondMealText.text = "Margarita was a choice of King of England in 1851 year"
       secondMealText.numberOfLines = 0
       secondMealText.lineBreakMode = .byWordWrapping
       secondMealText.textColor = .darkGray
       
       secondMealPrice.font = UIFont.systemFont(ofSize: 16, weight: .bold)
       secondMealPrice.text = "1000 руб."
    }
    
    private func setupUI(){
        view.addSubview(orderButton)
        view.addSubview(bucket)
        view.addSubview(secondOrderButton)
        
        orderButton.setTitle("add to bucket", for: .normal)
        orderButton.backgroundColor = .orange
        orderButton.titleLabel?.textColor = .black
        orderButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        orderButton.clipsToBounds = true
        orderButton.layer.cornerRadius = 10
        orderButton.addTarget(self, action: #selector(didTapChorizzoOrder), for: .touchUpInside)
        
        secondOrderButton.setTitle("add to bucket", for: .normal)
        secondOrderButton.backgroundColor = .orange
        secondOrderButton.titleLabel?.textColor = .black
        secondOrderButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        secondOrderButton.clipsToBounds = true
        secondOrderButton.layer.cornerRadius = 10
        secondOrderButton.addTarget(self, action: #selector(didTapFourCheesezOrder), for: .touchUpInside)
        
        bucket.backgroundColor = .orange
        bucket.setTitle("0 р", for: .normal)
        bucket.setImage(UIImage.add, for: .normal)
        bucket.clipsToBounds = true
        bucket.layer.cornerRadius = 15
        bucket.addTarget(self, action: #selector(didTapBucket), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        firstMealImage.frame = CGRect(x: 18, y: 200, width: Int(view.frame.width / 2), height: 200)
        firstMealTitle.frame = CGRect(x: 18, y: 410, width: 100, height: 20)
        firstMealText.frame = CGRect(x: 18, y: 430, width: Int(view.frame.width / 2), height: 50)
        firstMealPrice.frame = CGRect(x: 18, y: 470, width: 140, height: 50)
        
        secondMealImage.frame = CGRect(x: 18, y: 510, width: Int(view.frame.width / 2), height: 200)
        secondMealTitle.frame = CGRect(x: 18, y: 710, width: 100, height: 20)
        secondMealText.frame = CGRect(x: 18, y: 730, width: Int(view.frame.width / 2), height: 50)
        secondMealPrice.frame = CGRect(x: 18, y: 770, width: 140, height: 50)
        
        orderButton.frame = CGRect(x: Int(view.frame.width / 2) + 50, y: 275, width: 140, height: 40)
        secondOrderButton.frame = CGRect(x: Int(view.frame.width / 2) + 50, y: 585, width: 140, height: 40)
        
        bucket.frame = CGRect(x: Int(view.frame.width - 180), y: Int(view.frame.height) - 150, width: 150, height: 50)
    }
    
    
    public var counters: [Int] = []

    //fetch counters

    private func fetchCounters(){
        DatabaseManager.shared.getCounters(email: currentEmail) { counters in
            self.counters = counters
            print("Found these counters of products: \(counters)")
            
        }
    }
    
    var counterOfChorizzo: Int = 0
    var counterOfFourCheesez: Int = 0
    
    private func getCounterOf_Chorizzo(){
        DatabaseManager.shared.getCounterOfChorizzo(email: currentEmail) {counterOfChorizzo in
            self.counterOfChorizzo = counterOfChorizzo
        }
    }
    
    private func getCounterOf_FourCheesez(){
        DatabaseManager.shared.getCounterOfFourCheesez(email: currentEmail) {counterOfFourCheesez in
            self.counterOfFourCheesez = counterOfFourCheesez
        }
    }
    
    @objc func didTapChorizzoOrder(){
        
//        notificationGenerator.notificationOccurred(.success)
        
        orderButton.setTitleColor(.black, for: .highlighted)
        
        animateChirzzo()
        
        DispatchQueue.main.async {
            self.getCounterOf_Chorizzo()
            print(" product counter chorizzo number is \(self.counterOfChorizzo)")
           
            DatabaseManager.shared.updateCounter(email: self.currentEmail,
                                                 productName: "chorizzo",
                                                 updateInt: self.counterOfChorizzo + 1) { updated in
                guard updated else {
                    return
                }
            }
            self.fetchPreOrderData()
        }
    }
    
    @objc func didTapFourCheesezOrder(){
        
//        notificationGenerator.notificationOccurred(.success)
        
        secondOrderButton.setTitleColor(.black, for: .highlighted)
        
        DispatchQueue.main.async {
            self.getCounterOf_FourCheesez()
            print(" product counter FourCheesez number is \(self.counterOfFourCheesez)")

            
            DatabaseManager.shared.updateCounter(email: self.currentEmail,
                                                 productName: "FourCheesez",
                                                 updateInt: self.counterOfFourCheesez + 1) { updated in
                guard updated else {
                    return
                }
            }
            self.fetchPreOrderData()
        }
    }
    
    @objc func didTapBucket(){
        DispatchQueue.main.async {
            let vc = BucketTabViewController()
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .formSheet
            self.present(navVc, animated: true)
        }
    }
    
}
