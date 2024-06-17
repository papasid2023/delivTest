//
//  TabBarViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    var sumForBadge: Int = 0
    
    let nav1 = UINavigationController(rootViewController: CatalogViewController())
//    let nav2 = UINavigationController(rootViewController: MainViewController())
    let nav3 = UINavigationController(rootViewController: BucketTabViewController())
    let nav4 = UINavigationController(rootViewController: UserViewController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        fetchCountOfAllOrdersForBucket()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNewPreOrderNotification),
                                               name: .didCreateNewPreOrder, object: nil)
        
        
        
        tabBar.isTranslucent = true
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.addSubview(blurView)
        
        
        nav1.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(systemName: "storefront.circle.fill"), tag: 1)
//        nav2.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "house.fill"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Bucket", image: UIImage(systemName: "basket.fill"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "user", image: UIImage(systemName: "person.circle.fill"), tag: 4)
        
        
        setViewControllers([nav1, nav3, nav4], animated: true)
    }
    
    @objc private func didReceiveNewPreOrderNotification() {
        DispatchQueue.main.async {
            self.fetchCountOfAllOrdersForBucket()
            self.nav3.tabBarItem.badgeValue = String(self.sumForBadge)
        }
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self, name: .didCreateNewPreOrder, object: nil)
        }
    
    public var orders: [productPreOrderData] = []
    
    public func fetchCountOfAllOrdersForBucket(){
        print("fetching ordersData")
        DatabaseManager.shared.getPreOrderData(email: currentEmail) { [weak self] orders in
            self?.orders = orders
            print("orders found in tabbar \(orders.count)")
            
            var sumOfAllOrders: Int = 0
            
            for order in orders {
                let sum = order.counter
                sumOfAllOrders += sum
            }
            
            DispatchQueue.main.async {
                self?.sumForBadge = sumOfAllOrders
                self?.nav3.tabBarItem.badgeValue = String(self?.sumForBadge ?? 0)
            }
        }
        
    }
    
    
    
}
