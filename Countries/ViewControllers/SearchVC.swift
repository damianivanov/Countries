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
    let buttonsView = UIView()
    let searchCountryButton = CFButton(backgroundColor: .systemRed, title: "Search Country")
    let allCountriesButton = CFButton(backgroundColor: .systemGreen, title: "All Countries")
    var isCountryEntered: Bool { return !countryTextField.text!.isEmpty }
    let buttonPadding: CGFloat = 40
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureConstraints()
        configureButtonsView()
        configureSubViews()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        addObservers()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureButtonsView() {
        buttonsView.addSubviews(allCountriesButton, searchCountryButton)
        NSLayoutConstraint.activate([
            allCountriesButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: -Constants.padding),
            allCountriesButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: buttonPadding),
            allCountriesButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: -buttonPadding),
            allCountriesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            searchCountryButton.bottomAnchor.constraint(equalTo: allCountriesButton.topAnchor,
                                                        constant: -Constants.padding),
            searchCountryButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: buttonPadding),
            searchCountryButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor,
                                                          constant: -buttonPadding),
            searchCountryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func configureUI() {
        view.addSubviews(logoImageView, countryTextField, buttonsView, allCountriesButton, searchCountryButton)
        view.tamicFalse()
    }

    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }

    private func configureSubViews() {
        logoImageView.image = UIImage(named: Constants.logoImagePath)!
        countryTextField.delegate = self
        searchCountryButton.addTarget(self, action: #selector(pushDetailsVC), for: .touchUpInside)
        allCountriesButton.addTarget(self, action: #selector(pushAllCountriesVC), for: .touchUpInside)
    }

    private func configureConstraints() {
        let buttonsViewHeight = CGFloat(2*Constants.buttonHeight + 3*Constants.padding)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: screenWidth*0.9),

            countryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Constants.padding),
            countryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding),
            countryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            countryTextField.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.padding),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: buttonsViewHeight)

        ])
    }

    @objc func pushAllCountriesVC() {
        let allCountriesVC = AllCountriesVC()
        navigationController?.pushViewController(allCountriesVC, animated: true)
    }

    @objc private func pushDetailsVC() {
        guard isCountryEntered else {
            presentCFAlertOnMainThread(title: Messages.emptyCountry,
                                       bodyMessage: Messages.emptyCountrySearch, buttonText: Messages.okMessage)
            return
        }
        let nav = Utils.shared.getSheetDetailsVC(countryName: countryTextField.text!)
        countryTextField.resignFirstResponder()
        present(nav, animated: true, completion: nil)
        countryTextField.text = ""
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.frame.origin.y = 0 - keyboardSize.height + (tabBarController?.tabBar.frame.height ?? 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.frame.origin.y = 0
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushDetailsVC()
        return true
    }
}
