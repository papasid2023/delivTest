//
//  customCellforPreOrders.swift
//  reminder
//
//  Created by Руслан Сидоренко on 21.05.2024.
//

import UIKit
import FirebaseAuth

public let email = Auth.auth().currentUser?.email ?? ""

class viewPreOrdersModel {
    let price: String
    let productName: String
    let nameOfImage: String
    
    init(price: String, productName: String, nameOfImage: String) {
        self.price = price
        self.productName = productName
        self.nameOfImage = nameOfImage
    }
}

class customCellforPreOrders: UITableViewCell {
    
    static let identifier = "customCellforPreOrders"
    
    private let productName: UILabel = {
        let productName = UILabel()
        productName.textColor = .black
        productName.font = UIFont.systemFont(ofSize: 18, weight: .medium)
       return productName
    }()
    
    private let price: UILabel = {
       let price = UILabel()
        price.textColor = .black
        price.font = UIFont.systemFont(ofSize: 14, weight: .regular)
       return price
    }()
    
    private let nameOfImage: String = {
        let nameOfImage = String()
        return nameOfImage
    }()
    
    private let imageOfProduct: UIImageView = {
        let imageOfProduct = UIImageView()
        imageOfProduct.clipsToBounds = true
        imageOfProduct.layer.cornerRadius = 15
        imageOfProduct.contentMode = .scaleAspectFill
        return imageOfProduct
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(productName)
        contentView.addSubview(price)
        contentView.addSubview(imageOfProduct)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageOfProduct.frame = CGRect(x: 18,
                                      y: 18,
                                      width: 170,
                                      height: 170)
        productName.frame = CGRect(x: 200,
                                   y: 80,
                                   width: 150,
                                   height: 20)
        price.frame = CGRect(x: 200,
                             y: 100,
                             width: 100,
                             height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageOfProduct.image = UIImage(named: nameOfImage)
        productName.text = nil
        price.text = nil
        
    }
    
    func configure(with viewPreOrdersModel: viewPreOrdersModel){
        imageOfProduct.image = UIImage(named: viewPreOrdersModel.nameOfImage)
        productName.text = viewPreOrdersModel.productName
        price.text = "\(viewPreOrdersModel.price) rub"
        
    }
}
