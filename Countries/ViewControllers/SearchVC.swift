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

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), 
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
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
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: screenWidth*0.9),

            allCountriesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonHeight),
            allCountriesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            allCountriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            allCountriesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            countryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Constants.padding),
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
        countryTextField.resignFirstResponder()
        present(nav, animated: true, completion: nil)
        countryTextField.text = ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushDetailsVC()
        return true
    }
}
