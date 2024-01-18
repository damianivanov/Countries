//
//  CFCountryInfo.swift
//  Countries
//
//  Created by Damian Ivanov on 15.01.24.
//

import UIKit

class CFCountryInfo: UIViewController {
    var countryName = ""
    
    var body = CFBodyLabel(frame: .zero)
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(countryName: String) {
        super.init(nibName: nil, bundle: nil)
        self.countryName = countryName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
