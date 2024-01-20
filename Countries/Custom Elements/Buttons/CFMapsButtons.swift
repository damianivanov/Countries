//
//  CFMapsButtons.swift
//  Countries
//
//  Created by Damian Ivanov on 19.01.24.
//

import UIKit

class CFMapsButtons: UIViewController {

    var country: Country?
    var appleMapButton = CFButton(backgroundColor: .red, title: "Apple Maps")
    var googleMapsButton = CFButton(backgroundColor: .red, title: "Google Maps")

    init(country: Country) {
        super.init(nibName: nil, bundle: nil)
        self.country = country
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        view.addSubviews(appleMapButton, googleMapsButton)
        view.tamicFalse()
        configureUI()
        appleMapButton.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        googleMapsButton.addTarget(self, action: #selector(googleMap), for: .touchUpInside)
    }

    private func configureUI() {
//        view.backgroundColor = .red
        NSLayoutConstraint.activate([
            appleMapButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding),
            appleMapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            appleMapButton.widthAnchor.constraint(equalToConstant:
                                                    Utils.shared.getButtonWidth(viewWidth: view.bounds.width)),
            appleMapButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            googleMapsButton.centerYAnchor.constraint(equalTo: appleMapButton.centerYAnchor),
            googleMapsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            googleMapsButton.widthAnchor.constraint(equalToConstant:
                                                        Utils.shared.getButtonWidth(viewWidth: view.bounds.width)),
            googleMapsButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])

    }

    @objc private func openMap() {
        guard let country  = country else {return}
        let urlString = "https://maps.apple.com/?q=\(country.urlName)"
        guard let url = URL(string: urlString) else {return}
        UIApplication.shared.open(url, options: [:]) { _ in}
    }

    @objc private func googleMap() {
        guard let country  = country else {return}
        let urlString = country.maps.googleMaps
        guard let url = URL(string: urlString) else {return}
        UIApplication.shared.open(url, options: [:]) { _ in}
    }
}
