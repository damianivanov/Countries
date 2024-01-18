//
//  UIViewController+Ext.swift
//  Countries
//
//  Created by Damian Ivanov on 4.01.24.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
    
    func presentCFAlertOnMainThread(title:String, bodyMessage: String, buttonText: String) {
        DispatchQueue.main.async{
            let alertVC = CFAlertVC(title: title, message: bodyMessage, buttonTitle: buttonText)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(loadingIndicator)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        
        loadingIndicator.startAnimating()
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async{
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
    func emptyStateView(message: String, in view: UIView){
        let emptyView = CFEmptyView(message: message)
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
    }
}
