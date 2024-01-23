//
//  CFCountryFlag.swift
//  Countries
//
//  Created by Damian Ivanov on 7.01.24.
//

import UIKit

class CFCountryFlag: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func downloadFlag(urlString: String) {
        Task {
            image = await NetworkManager.shared.downloadFlagImage(flagURL: urlString)
            ?? UIImage(named: "placeholderImage")
        }
    }
}
