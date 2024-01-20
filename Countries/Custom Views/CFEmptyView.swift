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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(message: String) {
        super.init(frame: .zero)
        self.messageString = message
        configure()
    }

    private func configure() {
        addSubview(message)
        /*tamicFalse()*/
        configureUI()
    }

    private func configureUI() {
        NSLayoutConstraint.activate([

            message.centerYAnchor.constraint(equalTo: centerYAnchor),
            message.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            message.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            message.heightAnchor.constraint(equalToConstant: 200)

        ])

        message.numberOfLines = 3
        message.text = messageString
        message.textColor = .secondaryLabel

    }

}
