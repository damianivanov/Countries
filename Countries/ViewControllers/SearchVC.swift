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
    
    
    func configureUI(){
        view.addSubviews(logoImageView,countryTextField,allCountriesButton,searchCountryButton)
        view.tamicFalse()
    }
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
    }
    
    
    func configureLogoImageView() {
        logoImageView.image = UIImage(named: Constants.logoImagePath)!
        logoImageView.contentMode = .scaleToFill
        
    }
    
    func configureConstraints(){
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 320),
            logoImageView.heightAnchor.constraint(equalToConstant: 270),
            
            allCountriesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            allCountriesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            allCountriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            allCountriesButton.heightAnchor.constraint(equalToConstant: 50),
            
            countryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            countryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            countryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            countryTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchCountryButton.bottomAnchor.constraint(equalTo: allCountriesButton.topAnchor, constant: -10),
            searchCountryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            searchCountryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            searchCountryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureTextField() {
        countryTextField.delegate = self
    }
    
    
    func configureAllCountriesButton(){
        allCountriesButton.addTarget(self, action: #selector(pushAllCountriesVC), for: .touchUpInside)
    }
    
    
    func configureSearchButton(){
        searchCountryButton.addTarget(self, action: #selector(pushDetailsVC), for: .touchUpInside)

    }
    
    @objc func pushAllCountriesVC() {
        let allCountriesVC = AllCountriesVC()
        navigationController?.pushViewController(allCountriesVC, animated: true)
    }
    
    @objc func pushDetailsVC() {
        guard isCountryEntered else {
            presentCFAlertOnMainThread(title: "Empty Country", bodyMessage: "You have to enter a country name.", buttonText: "OK")
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
