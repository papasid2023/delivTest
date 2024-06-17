//
//  CatalogViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 26.05.2024.
//

import UIKit
import FirebaseAuth

class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    
    let notificationGenerator = UINotificationFeedbackGenerator()
    
    private let bucket = UIButton()
    
    private let currentEmail = Auth.auth().currentUser?.email ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Choose your meal"
        setupTableView()
        setupUI()
        fetchPreOrderData()
        fetchAllProductsData()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNewPreOrderNotification),
                                               name: .didCreateNewPreOrder, object: nil)
    }
    
    @objc private func didReceiveNewPreOrderNotification() {
        DispatchQueue.main.async {
            self.fetchPreOrderData()
        }
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self, name: .didCreateNewPreOrder, object: nil)
        }
    
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(customCellforPreOrders.self, forCellReuseIdentifier: customCellforPreOrders.identifier)
    }
    
    private func setupUI(){
        view.addSubview(bucket)
        
        bucket.backgroundColor = .orange
        bucket.setTitle("0 р", for: .normal)
        bucket.setImage(UIImage(systemName: "basket"), for: .normal)
        bucket.tintColor = .white
        
        bucket.clipsToBounds = true
        bucket.layer.cornerRadius = 15
        bucket.addTarget(self, action: #selector(didTapBucket), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bucket.frame = CGRect(x: 18, y: Int(view.frame.height) - 150, width: 150, height: 50)
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
    
    
    private func fetchAllProductsData(){
        
        print("fetching in catalog...")
        
        DatabaseManager.shared.getAllProductsData(email: currentEmail) { [weak self] orders in
            self?.orders = orders
            
            print("Catalog list was found \(orders.count)")
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
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
    
    var counterOfFourCheesez: Int = 0
    var counterOfParmPork: Int = 0
    var counterOfPiggy: Int = 0
    var counterOfChorizzo: Int = 0
    
    private func getCounterOf_FourCheesez(){
        DatabaseManager.shared.getCounterOfFourCheesez(email: currentEmail) {getCounterOfFourCheesez in
            self.counterOfFourCheesez = getCounterOfFourCheesez
        }
    }
    
    private func getCounterOf_ParmPork(){
        DatabaseManager.shared.getCounterOfParmPork(email: currentEmail) {getCounterOfParmPork in
            self.counterOfParmPork = getCounterOfParmPork
        }
    }
    
    private func getCounterOf_Piggy(){
        DatabaseManager.shared.getCounterOfPiggy(email: currentEmail) {getCounterOfPiggy in
            self.counterOfPiggy = getCounterOfPiggy
        }
    }
    
    private func getCounterOf_Chorizzo(){
        DatabaseManager.shared.getCounterOfChorizzo(email: currentEmail) {counterOfChorizzo in
            self.counterOfChorizzo = counterOfChorizzo
        }
    }
}

extension CatalogViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = CustomViewOfCell(product: orders[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ordersData = orders[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellforPreOrders.identifier, for: indexPath) as? customCellforPreOrders else {
            fatalError()
        }
        
        cell.configure(with: viewPreOrdersModel(price: String(ordersData.price),
                                                productName: ordersData.name,
                                                nameOfImage: ordersData.image ))
        
        let addButton = UIButton()
        cell.addSubview(addButton)
        addButton.setTitle("BUY", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        addButton.backgroundColor = .orange
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 7
        addButton.frame = CGRect(x: 200, y: 150, width: 50, height: 20)
        addButton.tag = indexPath.row
        addButton.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 206
    }
    
    @objc func didTapAddButton(_ sender: UIButton){
        let index = sender.tag
        
        switch index {
            
            case 0:
            print("4 cheesez")
            
            notificationGenerator.notificationOccurred(.success)
            
            sender.setTitleColor(.black, for: .highlighted)
            
            DispatchQueue.main.async {
                self.getCounterOf_FourCheesez()
                print(" product counter FourCheesez number is \(self.counterOfFourCheesez)")
                NotificationCenter.default.post(name: .didCreateNewPreOrder, object: nil)
                
                DatabaseManager.shared.updateCounter(email: self.currentEmail,
                                                     productName: "FourCheesez",
                                                     updateInt: self.counterOfFourCheesez + 1) { updated in
                    guard updated else {
                        return
                    }
                    
                }
                self.fetchPreOrderData()
            }
            
            case 1:
            print("parm pork")
            
            notificationGenerator.notificationOccurred(.success)
            
            sender.setTitleColor(.black, for: .highlighted)
            
            DispatchQueue.main.async {
                self.getCounterOf_ParmPork()
                print(" product counter parm pork number is \(self.counterOfParmPork)")
                NotificationCenter.default.post(name: .didCreateNewPreOrder, object: nil)
                
                DatabaseManager.shared.updateCounter(email: self.currentEmail,
                                                     productName: "ParmPork",
                                                     updateInt: self.counterOfParmPork + 1) { updated in
                    guard updated else {
                        return
                    }
                }
                self.fetchPreOrderData()
            }
            case 2:
            print("piggy")
            
            notificationGenerator.notificationOccurred(.success)
            
            sender.setTitleColor(.black, for: .highlighted)
            
            DispatchQueue.main.async {
                self.getCounterOf_Piggy()
                print(" product counter piggy number is \(self.counterOfPiggy)")
                NotificationCenter.default.post(name: .didCreateNewPreOrder, object: nil)
                
                DatabaseManager.shared.updateCounter(email: self.currentEmail,
                                                     productName: "Piggy",
                                                     updateInt: self.counterOfPiggy + 1) { updated in
                    guard updated else {
                        return
                    }
                }
                self.fetchPreOrderData()
            }
            case 3:
            print("chorizzo")
            
            sender.setTitleColor(.black, for: .highlighted)
            
            DispatchQueue.main.async {
                self.getCounterOf_Chorizzo()
                print(" product counter chorizzo number is \(self.counterOfChorizzo)")
                NotificationCenter.default.post(name: .didCreateNewPreOrder, object: nil)
                
                DatabaseManager.shared.updateCounter(email: self.currentEmail,
                                                     productName: "chorizzo",
                                                     updateInt: self.counterOfChorizzo + 1) { updated in
                    guard updated else {
                        return
                    }
                }
                self.fetchPreOrderData()
            }
            default:
            print("null")
        }
        
        
        
    }
    
    
    
}
