//
//  FavoritesViewCell.swift
//  Countries
//
//  Created by Damian Ivanov on 15.01.24.
//

import UIKit

class FavoritesViewCell: UICollectionViewCell {

    static var cellIdentifier = "FavoriteCell"
    var flagImage = CFCountryFlag(frame: .zero)
    var countryNameTitle = CFTitleLabel(textAlignment: .left, fontSize: 20, weight: .bold)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(countryNameTitle, flagImage)
        configureConstraints()
    }

    convenience init(backgroundColor: UIColor, country: CountryShort) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        set(country)
    }

    func set(_ country: CountryShort) {
        countryNameTitle.text = country.name.common
        flagImage.image = nil
        flagImage.downloadFlag(urlString: country.flags.png)
    }

    private func configureConstraints() {
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
}
