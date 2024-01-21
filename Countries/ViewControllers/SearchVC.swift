//
//  SearchVC.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class SearchVC: UIViewController {

    var screenWidth = UIScreen.main.bounds.width
    let logoImageView = UIImageView()
    let countryTextField = CFTextField()
    let searchCountryButton = CFButton(backgroundColor: .systemRed, title: "Search Country")
    let allCountriesButton = CFButton(backgroundColor: .systemGreen, title: "All Countries")
    var isCountryEntered: Bool { return !countryTextField.text!.isEmpty }
    let buttonPadding: CGFloat = 40

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureConstraints()

        configureLogoImageView()
        configureTextField()
        configureAllCountriesButton()
        configureSearchButton()
        createDismissKeyboardTapGesture()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }

    func configureUI() {
        view.addSubviews(logoImageView, countryTextField, allCountriesButton, searchCountryButton)
        view.tamicFalse()
    }

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)

    }

    func configureLogoImageView() {
        logoImageView.image = UIImage(named: Constants.logoImagePath)!
        logoImageView.contentMode = .scaleToFill

    }

    func configureConstraints() {

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: screenWidth*0.9),

            allCountriesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.padding),
            allCountriesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            allCountriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            allCountriesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            countryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            countryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            countryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            countryTextField.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            searchCountryButton.bottomAnchor.constraint(equalTo: allCountriesButton.topAnchor,
                                                        constant: -Constants.padding),
            searchCountryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            searchCountryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            searchCountryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    func configureTextField() {
        countryTextField.delegate = self
    }

    func configureAllCountriesButton() {
        allCountriesButton.addTarget(self, action: #selector(pushAllCountriesVC), for: .touchUpInside)
    }

    func configureSearchButton() {
        searchCountryButton.addTarget(self, action: #selector(pushDetailsVC), for: .touchUpInside)

    }

    @objc func pushAllCountriesVC() {
        let allCountriesVC = AllCountriesVC()
        navigationController?.pushViewController(allCountriesVC, animated: true)
    }

    @objc func pushDetailsVC() {
        guard isCountryEntered else {
            presentCFAlertOnMainThread(title: Messages.emptyCountry,
                                       bodyMessage: Messages.emptyCountrySearch, buttonText: Messages.okMessage)
            return
        }

        let detailsVC = DetailsVC()
        detailsVC.countryName = countryTextField.text
        let nav = Utils.shared.getSheetDetailsVC(countryName: countryTextField.text!)
        present(nav, animated: true, completion: nil)
        countryTextField.text = ""
    }

}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushDetailsVC()
        return true
    }
}
