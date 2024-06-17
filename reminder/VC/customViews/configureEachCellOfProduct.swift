//
//  configureEachCellOfProduct.swift
//  reminder
//
//  Created by Руслан Сидоренко on 26.05.2024.
//

import UIKit

class configureEachCellOfProductModel {
    let productName: String
    let price: String
    let nameOfImage: String
    let description: String
    
    init(productName: String, price: String, nameOfImage: String, description: String) {
        self.productName = productName
        self.price = price
        self.nameOfImage = nameOfImage
        self.description = description
    }
}

class configureEachCellOfProduct: UITableViewCell {
    
    static let identifier = "configureEachCellOfProduct"
    
    private let productName: UILabel = {
        let productName = UILabel()
        productName.font = UIFont.systemFont(ofSize: 18, weight: .medium)
       return productName
    }()
    
    private let price: UILabel = {
       let price = UILabel()
        price.textColor = .orange
        price.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
    
    private let descriptionn: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        description.lineBreakMode = .byWordWrapping
        description.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(productName)
        contentView.addSubview(price)
        contentView.addSubview(imageOfProduct)
        contentView.addSubview(descriptionn)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        imageOfProduct.frame = CGRect(x: 18,
                                      y: 18,
                                      width: 300,
                                      height: 300)
        productName.frame = CGRect(x: 18,
                                   y: 330,
                                   width: 150,
                                   height: 20)
        price.frame = CGRect(x:18,
                             y: 355,
                             width: 100,
                             height: 20)
        
        descriptionn.frame = CGRect(x:18,
                             y: 380,
                             width: 300,
                             height: 200)
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productName.text = nil
        price.text = nil
        imageOfProduct.image = UIImage(named: nameOfImage)
        descriptionn.text = nil
    }
    
    func configure(with configureEachCellOfProductModel: configureEachCellOfProductModel){
        productName.text = configureEachCellOfProductModel.productName
        price.text = ("\(configureEachCellOfProductModel.price) rub")
        imageOfProduct.image = UIImage(named: configureEachCellOfProductModel.nameOfImage)
        descriptionn.text = configureEachCellOfProductModel.description
        
        
    }
}

