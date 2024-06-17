//
//  hideKeyboard.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit

extension UIViewController {
    
    public func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAround))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = true
    }
    
    @objc func didTapAround(){
        view.endEditing(true)
    }
    
}
