//
//  SearchVC.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoName = "countriesLogo.png"
    let logoImageView = UIImageView()
    let countryTextField = CFTextField()
    let searchCountryButton = CFButton(backgroundColor: .systemRed, title: "Search Country")
    var isCountryEntered: Bool { return !countryTextField.text!.isEmpty }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureSearchButton()
        createDismissKeyboardTapGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @objc func pushDetailsVC() {
        
        guard isCountryEntered else {
            presentCFAlertOnMainThread(title: "Empty Country", bodyMessage: "You have to enter a country name.", buttonText: "OK")
            return
        }
        let detailsVC = DetailsVC()
        detailsVC.country = countryTextField.text
        detailsVC.title = countryTextField.text
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: logoName)!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 175)
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(countryTextField)
        countryTextField.delegate = self
        NSLayoutConstraint.activate([
            countryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            countryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            countryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            countryTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureSearchButton(){
        view.addSubview(searchCountryButton)
        searchCountryButton.addTarget(self, action: #selector(pushDetailsVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchCountryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            searchCountryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            searchCountryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            searchCountryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushDetailsVC()
        return true
    }
}
