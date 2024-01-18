//
//  CFBodyLabel.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class CFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, textAlignment: NSTextAlignment, fontSize: CGFloat){
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        self.textAlignment = textAlignment
        configure()
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat){
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        self.textAlignment = textAlignment
        configure()
    }
    
    
    func configure(){
        
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 1
        backgroundColor = .systemBackground
        lineBreakMode = .byWordWrapping
        numberOfLines = 10
        
    }

}
