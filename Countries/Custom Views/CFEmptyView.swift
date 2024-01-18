//
//  CFEmptyView.swift
//  Countries
//
//  Created by Damian Ivanov on 18.01.24.
//

import UIKit

class CFEmptyView: UIView {
    
    
    var messageString: String = ""
    let message = CFTitleLabel(textAlignment: .center, fontSize: 30, weight: .bold)
    let image = UIImageView(image: UIImage(named: Constants.logoImagePath)!)
    
    

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

    init(message: String) {
        super.init(frame: .zero)
        self.messageString = message
    }
    
    
    private func connfigure() {
        addSubviews(message,image)
        tamicFalse()
        configureUI()
    }
    
    private func configureUI(){
        NSLayoutConstraint.activate([
            
            message.centerXAnchor.constraint(equalTo: centerXAnchor),
            message.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        ])
        
        message.text = messageString
        message.backgroundColor = .secondaryLabel
        
    }
    
}
