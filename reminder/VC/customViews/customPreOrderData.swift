//
//  customPreOrderData.swift
//  reminder
//
//  Created by Руслан Сидоренко on 23.05.2024.
//

import UIKit
import FirebaseAuth

public let currentEmail = Auth.auth().currentUser?.email ?? ""

class customPreOrderDataModel {
    let name: String
    let price: Int
    let counter: Int
    let nameOfImage: String
    
    let minusButton: UIButton
    let plusButton: UIButton

    init(name: String, price: Int, counter: Int,
         minusButton: UIButton, plusButton: UIButton, nameOfimage: String) {
        
        self.name = name
        self.price = price
        self.counter = counter
        self.nameOfImage = nameOfimage
        
        self.minusButton = minusButton
        self.plusButton = plusButton
    }
    
}



class customPreOrderData: UITableViewCell {

    static let identifier = "customCellforPreOrderData"
    
    private var orderData: productPreOrderData?
    weak var delegate: customPreOrderDataDelegate?

    //MARK: first product
    private let name: UILabel = {
       let firstProductName = UILabel()
        firstProductName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
       return firstProductName
    }()
    
    private let price: UILabel = {
       let firstProductPrice = UILabel()
        firstProductPrice.font = UIFont.systemFont(ofSize: 10, weight: .regular)
       return firstProductPrice
    }()
    
    private let counter: UILabel = {
       let firstProductCounter = UILabel()
        firstProductCounter.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        firstProductCounter.textColor = .white
        firstProductCounter.backgroundColor = .orange
       return firstProductCounter
    }()
    
    private let nameOfImage: String = {
        let nameOfImage = String()
        return nameOfImage
    }()
    
    private let image: UIImageView = {
        let firstProductImage = UIImageView()
        firstProductImage.clipsToBounds = true
        firstProductImage.layer.cornerRadius = 5
        firstProductImage.contentMode = .scaleAspectFill
        return firstProductImage
    }()
    
    private let minusButton: UIButton = {
        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.backgroundColor = .orange
        minusButton.clipsToBounds = true
        minusButton.layer.cornerRadius = 8
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        return minusButton
    }()
    
    private let plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.backgroundColor = .orange
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = 8
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        return plusButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.addSubview(image)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        contentView.addSubview(counter)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        name.frame = CGRect(x: 18, y: 10, width: 150, height: 20)
        price.frame = CGRect(x: 18, y: 25, width: 100, height: 20)
        image.frame = CGRect(x: 18, y: 45, width: 100, height: 100)
        
        
        
        minusButton.frame = CGRect(x: Int(contentView.safeAreaLayoutGuide.layoutFrame.width) - 120,
                                  y: Int(contentView.safeAreaLayoutGuide.layoutFrame.height - 50),
                                  width: 55,
                                  height: 25)
        counter.frame = CGRect(x: Int(contentView.safeAreaLayoutGuide.layoutFrame.width) - 75,
                               y: Int(contentView.safeAreaLayoutGuide.layoutFrame.height - 50),
                               width: 35,
                               height: 25)
        
        plusButton.frame = CGRect(x: Int(contentView.safeAreaLayoutGuide.layoutFrame.width) - 50,
                                  y: Int(contentView.safeAreaLayoutGuide.layoutFrame.height - 50),
                                  width: 35,
                                  height: 25)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        price.text = nil
        counter.text = nil
        image.image = nil
    }
    
    func configure(with orderData: productPreOrderData) {
            self.orderData = orderData
            name.text = orderData.name
            price.text = "\(orderData.price) rubles"
            counter.text = "\(orderData.counter)"
            image.image = UIImage(named: orderData.image)
        }
    
    
    @objc func didTapMinus(){
        guard let orderData = orderData else { return }
        delegate?.didTapMinus(orderData: orderData)
        
    }
    
    @objc func didTapPlus(){
        guard let orderData = orderData else { return }
        delegate?.didTapPlus(orderData: orderData)
    }
}
