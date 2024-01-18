//
//  CFCountryFlag.swift
//  Countries
//
//  Created by Damian Ivanov on 7.01.24.
//

import UIKit


class CFCountryFlag: UIImageView {
    
    var cache = NetworkManager.shared.cache
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    private func configure(){
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func downloadFlag(urlString: String){
        NetworkManager.shared.downlodImage(imageURL: urlString)  {[weak self] data, error in 
            guard let self = self else {return}
            if let data = data {
                DispatchQueue.main.async {
                    self.image = data
                }
            }
        }
    }
}