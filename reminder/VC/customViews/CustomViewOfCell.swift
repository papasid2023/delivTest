//
//  CustomViewOfCell.swift
//  reminder
//
//  Created by Руслан Сидоренко on 26.05.2024.
//

import UIKit

class CustomViewOfCell: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let product: productPreOrderData
    
    init(product: productPreOrderData) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        return table
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(configureEachCellOfProduct.self, forCellReuseIdentifier: configureEachCellOfProduct.identifier)
    }
    
    public var orders: [productPreOrderData] = []
    
    private func fetchPreOrderData(){
        print("fetching ordersData")
        DatabaseManager.shared.getPreOrderData(email: currentEmail) { [weak self] orders in
            self?.orders = orders
            print("orders found \(orders.count)")
            
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        switch index {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: configureEachCellOfProduct.identifier,
                                                           for: indexPath) as? configureEachCellOfProduct else {
                fatalError()
            }
            cell.selectionStyle = .none
            cell.configure(with: .init(productName: product.name,
                                       price: String(product.price),
                                       nameOfImage: product.image,
                                       description: product.description))
            
            let addButton = UIButton()
            cell.addSubview(addButton)
            addButton.setTitle("BUY", for: .normal)
            addButton.setTitleColor(.white, for: .normal)
            addButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            addButton.backgroundColor = .orange
            addButton.clipsToBounds = true
            addButton.layer.cornerRadius = 7
            addButton.frame = CGRect(x: 18,
                                     y: 400,
                                     width: 50,
                                     height: 20)
            addButton.tag = indexPath.row
            addButton.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
            
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height
    }
    
    @objc func didTapAddButton(_ sender: UIButton){
        let index = sender.tag
        print(index)
    }

}
