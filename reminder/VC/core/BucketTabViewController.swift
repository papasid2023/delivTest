//
//  BucketTabViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 25.05.2024.
//

import UIKit
import FirebaseAuth



class BucketTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, customPreOrderDataDelegate  {
    
    func didTapMinus(orderData: productPreOrderData) {
        guard let index = orders.firstIndex(where: { $0.productId == orderData.productId }) else { return }
                if orders[index].counter > 0 {
                    orders[index].counter -= 1
                    let indexName = orders[index].name
                    print("\(indexName) was reduced by one position ---")
                    DatabaseManager.shared.updateOrder(email: currentEmail, orderData: orders[index]) { [weak self] success in
                        if success {
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                                self?.updateSumLabel()
                                NotificationCenter.default.post(name: .didCreateNewPreOrder, object: nil)
                            }
                        }
                    }
                }
    }
    
    func didTapPlus(orderData: productPreOrderData) {
        guard let index = orders.firstIndex(where: { $0.counter == orderData.counter }) else { return }
            orders[index].counter += 1
            let indexName = orders[index].name
            print("\(indexName) was increased by one position +++ ")
            DatabaseManager.shared.updateOrder(email: currentEmail, orderData: orders[index]) { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.updateSumLabel()
                        NotificationCenter.default.post(name: .didCreateNewPreOrder, object: nil)
                    }
                }
            }
    }

    let currentEmail = Auth.auth().currentUser?.email ?? ""
    private var tableView = UITableView()
    private var sum = UILabel()
    let makeOrder = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bucket"
        view.backgroundColor = .orange
        setupTableView()
        fetchPreOrderData()
        setupMakeOrder()
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
    
    private func setupMakeOrder(){
        view.addSubview(makeOrder)
        makeOrder.setTitle("Purchase", for: .normal)
        makeOrder.clipsToBounds = true
        makeOrder.layer.cornerRadius = 15
        makeOrder.backgroundColor = .blue
        makeOrder.addTarget(self, action: #selector(didTapMakeOrder), for: .touchUpInside)
    }
    
    @objc func didTapMakeOrder(){
        print("User \(currentEmail) get ready for make new order...")
    }
    
    
    
    
    private func updateSumLabel() {
            let sumOfAllOrders = orders.reduce(0) { $0 + $1.price * $1.counter }
            sum.text = "CHECK: \(sumOfAllOrders) rubles"
        }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(customPreOrderData.self, forCellReuseIdentifier: customPreOrderData.identifier)
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
                self?.tableView.reloadData()
                self?.setupSumOfPreOrder(sumOfAllPreOrder: sumOfAllOrders)
            }
        }
    }
    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ordersData = orders[indexPath.row]
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customPreOrderData.identifier, for: indexPath) as? customPreOrderData else {
            fatalError()
        }
        
       
        cell.configure(with: ordersData)
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    public func setupSumOfPreOrder(
        sumOfAllPreOrder: Int = 0
    ){
        view.addSubview(sum)
        sum.backgroundColor = .lightGray
        sum.clipsToBounds = true
        sum.layer.cornerRadius = 15
        sum.text = "CHECK: \(sumOfAllPreOrder) rubles"
        sum.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sum.frame = CGRect(x: 18,
                           y: Int(view.frame.maxY) - 160,
                           width: 200,
                           height: 50)
        
        makeOrder.frame = CGRect(x: Int(view.frame.width) - 160,
                                 y: Int(view.frame.maxY) - 160,
                                 width: 150,
                                 height: 50)
        
    }
    
}

extension Notification.Name {
    static let didCreateNewPreOrder = Notification.Name("didCreateNewPreOrder")
}

protocol customPreOrderDataDelegate: AnyObject {
    func didTapMinus(orderData: productPreOrderData)
    func didTapPlus(orderData: productPreOrderData)
}
