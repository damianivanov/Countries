//
//  CFTextField.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class CFTextField: UITextField {

    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        minimumFontSize = 13
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        
        autocorrectionType = .no
        backgroundColor = .tertiarySystemBackground
        returnKeyType = .search
        placeholder = "Enter a country"
        autocapitalizationType = .words
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
