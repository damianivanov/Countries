//
//  CountryCell.swift
//  Countries
//
//  Created by Damian Ivanov on 5.01.24.
//

import UIKit

class CountryCell: UITableViewCell {

    
    static var cellIdentifier = "countryCell"
    var Id = ""
    var flagImage = CFCountryFlag(frame: .zero)
    var countryNameTitle = CFTitleLabel(textAlignment: .left, fontSize: 20 ,weight: .bold)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(countryNameTitle)
        contentView.addSubview(flagImage)
        
        configureFlagImageView()
        configureCountryName()
        
    }
    
    func set(country: CountryShort) {
        countryNameTitle.text = country.name.common
        flagImage.image = nil
        flagImage.downloadFlag(urlString: country.flags.png)
        self.Id = Utils.shared.getFlagId(fromUrl: country.flags.png)
    }
    
    
    func configureFlagImageView(){
        flagImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flagImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            flagImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            flagImage.widthAnchor.constraint(equalToConstant: 50),
            flagImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
    func configureCountryName() {
        countryNameTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countryNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryNameTitle.leadingAnchor.constraint(equalTo: flagImage.trailingAnchor,constant: 10),
            countryNameTitle.heightAnchor.constraint(equalToConstant: 30),
            countryNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

}
