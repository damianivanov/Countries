//
//  CountryCell.swift
//  Countries
//
//  Created by Damian Ivanov on 5.01.24.
//

import UIKit

class CountryCell: UITableViewCell {

    static var cellIdentifier = "countryCell"
    var flagImage = CFCountryFlag(frame: .zero)
    var countryNameTitle = CFTitleLabel(textAlignment: .left, fontSize: 20, weight: .bold)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
        configureConstraints()

    }

    func configureUI() {
        backgroundColor = .systemBackground
        addSubviews(countryNameTitle, flagImage)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            flagImage.topAnchor.constraint(equalTo: topAnchor),
            flagImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            flagImage.widthAnchor.constraint(equalToConstant: 50),
            flagImage.bottomAnchor.constraint(equalTo: bottomAnchor),

            countryNameTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryNameTitle.leadingAnchor.constraint(equalTo: flagImage.trailingAnchor, constant: Constants.padding),
            countryNameTitle.heightAnchor.constraint(equalToConstant: 30),
            countryNameTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }

    func set(country: CountryShort) {
        countryNameTitle.text = country.name.common
        flagImage.image = nil
        flagImage.downloadFlag(urlString: country.flags.png)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
