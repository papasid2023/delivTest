//
//  BucketViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 21.05.2024.
//

import UIKit
import FirebaseAuth

protocol customPreOrderDataDelegatee: AnyObject {
    func didTapMinus(orderData: productPreOrderData)
    func didTapPlus(orderData: productPreOrderData)
}

class BucketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, customPreOrderDataDelegatee {
    
    func didTapMinus(orderData: productPreOrderData) {
        guard let index = orders.firstIndex(where: { $0.productId == orderData.productId }) else { return }
                if orders[index].counter > 0 {
                    orders[index].counter -= 1
                    DatabaseManager.shared.updateOrder(email: currentEmail, orderData: orders[index]) { [weak self] success in
                        if success {
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                                self?.updateSumLabel()
                            }
                        }
                    }
                }
    }
    
    func didTapPlus(orderData: productPreOrderData) {
        guard let index = orders.firstIndex(where: { $0.counter == orderData.counter }) else { return }
                orders[index].counter += 1
                DatabaseManager.shared.updateOrder(email: currentEmail, orderData: orders[index]) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.updateSumLabel()
                        }
                    }
                }
    }
    
    private func updateSumLabel() {
            let sumOfAllOrders = orders.reduce(0) { $0 + $1.price * $1.counter }
            sum.text = "CHECK: \(sumOfAllOrders) rubles"
        }
    
    let currentEmail = Auth.auth().currentUser?.email ?? ""
    private var tableView = UITableView()
    private var sum = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bucket"
        view.backgroundColor = .orange
        setupTableView()
        fetchPreOrderData()
        
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(customPreOrderData.self, forCellReuseIdentifier: customPreOrderData.identifier)
    }
    
//    public var counters: [Int] = []
//    
//    //fetch counters
//    
//    private func fetchCounters(){
//        DatabaseManager.shared.getCounters(email: currentEmail) { counters in
//            self.counters = counters
//            print("fount these counters: \(counters)")
//        }
//    }
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let anotherCell = UITableViewCell()
        let labelForAnotherCell = UILabel()
        anotherCell.addSubview(labelForAnotherCell)
        labelForAnotherCell.text = "Ooops! Your bucket is empty"
        labelForAnotherCell.frame = CGRect(x: 50, y: 50, width: 250, height: 100)
        
        let ordersData = orders[indexPath.row]
        
        guard ordersData.counter == 0 else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: customPreOrderData.identifier, for: indexPath) as? customPreOrderData else {
                fatalError()
            }
            
            cell.configure(with: .init(productId: ordersData.productId, name: ordersData.name, price: ordersData.price, counter: ordersData.counter, image: ordersData.image, description: ordersData.description))
            
            return cell
               
        }
        return anotherCell
        
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
        sum.text = "CHECK: \(sumOfAllPreOrder) rubles"
        sum.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sum.frame = CGRect(x: 18, y: Int(view.frame.maxY) - 100, width: 250, height: 50)
    }
}
