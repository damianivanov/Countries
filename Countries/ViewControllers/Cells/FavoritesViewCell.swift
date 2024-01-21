//
//  FavoritesViewCell.swift
//  Countries
//
//  Created by Damian Ivanov on 15.01.24.
//

import UIKit

class FavoritesViewCell: UICollectionViewCell {

    static var cellIdentifier = "FavoriteCell"
//    var Id: String = ""
    var flagImage = CFCountryFlag(frame: .zero)
    var countryNameTitle = CFTitleLabel(textAlignment: .left, fontSize: 20, weight: .bold)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        addSubviews(countryNameTitle, flagImage)

        configureConstraints()
    }

    func set(country: CountryShort) {
        countryNameTitle.text = country.name.common
        flagImage.image = nil
        flagImage.downloadFlag(urlString: country.flags.png)
//        self.Id = Utils.shared.getFlagId(fromUrl: country.flags.png)
    }
    func configureConstraints() {
        countryNameTitle.translatesAutoresizingMaskIntoConstraints = false
        flagImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            flagImage.topAnchor.constraint(equalTo: topAnchor),
            flagImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            flagImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagImage.heightAnchor.constraint(equalTo: flagImage.widthAnchor),

            countryNameTitle.topAnchor.constraint(equalTo: flagImage.bottomAnchor, constant: 5),
            countryNameTitle.leadingAnchor.constraint(equalTo: flagImage.leadingAnchor, constant: 5),
            countryNameTitle.trailingAnchor.constraint(equalTo: flagImage.trailingAnchor, constant: -5),
            countryNameTitle.heightAnchor.constraint(equalToConstant: 20)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.countryNameTitle = CFTitleLabel(frame: .zero)
        self.flagImage = CFCountryFlag(frame: .zero)
    }
}
