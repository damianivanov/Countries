//
//  UIViewController+Ext.swift
//  Countries
//
//  Created by Damian Ivanov on 4.01.24.
//

import UIKit

extension UIViewController {
    
    func presentCFAlertOnMainThread(title:String, bodyMessage: String, buttonText: String) {
        DispatchQueue.main.async{
            let alertVC = CFAlertVC(title: title, message: bodyMessage, buttonTitle: buttonText)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
