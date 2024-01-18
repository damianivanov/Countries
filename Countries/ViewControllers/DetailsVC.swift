//
//  DetailsVC.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit
import MapKit

class DetailsVC: UIViewController, UIScrollViewDelegate {
    
    
    var countryName: String!
    var country: Country!
    var countryShort: CountryShort?
    var headerView = UIView()
    var photosView = UIView()
    var appleMapButton = CFButton(backgroundColor: .red, title: "Apple Maps")
    var googleMapsButton = CFButton(backgroundColor: .red, title: "Google Maps")
    var countryInfo = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        
        configureNC()
        layoutUI()
        fetchCountry()
        configureUILabel()
        loadScrollView()
        loadCountryInfo()
    }
    
    
    @objc private func dismissVC(){
        //        photosView = UIView(frame: .zero)
        dismiss(animated: true)
    }
    
    @objc private func cancelVC(){
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    private func layoutUI(){
        view.addSubviews(headerView,photosView,countryInfo,appleMapButton,googleMapsButton)
        view.tamicFalse()
        
        appleMapButton.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        googleMapsButton.addTarget(self, action: #selector(googleMap), for: .touchUpInside)
        
        countryInfo.layer.cornerRadius = 15
        countryInfo.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.viewHeight),
            
            photosView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.padding),
            photosView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosView.heightAnchor.constraint(equalToConstant: Constants.heightScrollViewItem),
            
            countryInfo.topAnchor.constraint(equalTo: photosView.bottomAnchor, constant: Constants.padding),
            countryInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: Constants.padding),
            countryInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
//            countryInfo.heightAnchor.constraint(equalToConstant: Constants.viewHeight),
            
            appleMapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonPadding),
            appleMapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonPadding),
            appleMapButton.widthAnchor.constraint(equalToConstant: Utils.shared.getButtonWidth(viewWidth: view.bounds.width)),
            appleMapButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            googleMapsButton.centerYAnchor.constraint(equalTo: appleMapButton.centerYAnchor),
            googleMapsButton.leadingAnchor.constraint(equalTo: appleMapButton.trailingAnchor, constant: Constants.buttonSpacing),
            googleMapsButton.widthAnchor.constraint(equalToConstant: Utils.shared.getButtonWidth(viewWidth: view.bounds.width)),
            googleMapsButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
        
    }
    
    
    private func configureUILabel() {
        countryInfo.textColor = .secondaryLabel
        countryInfo.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        countryInfo.backgroundColor = .systemBackground
        countryInfo.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right:5);
        countryInfo.isEditable = false
        countryInfo.showsVerticalScrollIndicator = false
    }
    
    private func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func configureNC() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelVC))
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    private func fetchCountry() {
        NetworkManager.shared.getCountry(country: countryName) { [weak self] country, error in
            guard let self = self else {return}
            guard let country = country else {
                self.presentCFAlertOnMainThread(title: "Something went wrong", bodyMessage: error?.rawValue ?? "", buttonText: "Ok")
                DispatchQueue.main.async{
                    self.appleMapButton.isHidden = true
                    self.googleMapsButton.isHidden = true
                }
                return
            }
            DispatchQueue.main.async{
                guard let country = country.first else {return}
                self.country = country
                self.add(childVC: CFHeaderInfo(country: country), to: self.headerView)
            }
        }
    }
    
    private func loadScrollView(){
        DispatchQueue.main.async{
            self.add(childVC: CFScrollableView(countryName: self.countryName), to: self.photosView)
            self.photosView.tag = 10
        }
    }
    
    private func loadCountryInfo(){
        NetworkManager.shared.getCountryDescription(country: countryName) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                updateUI(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUI(_ response: QueryResponse){
        guard let longInfo = response.query.pages.first?.value.extract else {return}
        DispatchQueue.main.async{
            let text = Utils.shared.reduceCountryInfo(longInfo: longInfo, sentencesCount: 4)
            self.countryInfo.text = text
            NSLayoutConstraint.activate([
                self.countryInfo.heightAnchor.constraint(equalToConstant: self.countryInfo.contentSize.height)
            ])
            self.countryInfo.sizeToFit()
        }
    }
    
    @objc private func openMap() {
        let urlString = "https://maps.apple.com/?q=\((country?.urlName)!)"
        guard let url = URL(string: urlString) else {return}
        UIApplication.shared.open(url, options: [:]) { result in}
    }
    
    @objc private func googleMap() {
        let urlString = country.maps.googleMaps
        guard let url = URL(string: urlString) else {return}
        UIApplication.shared.open(url, options: [:]) { result in}
    }
    
}
