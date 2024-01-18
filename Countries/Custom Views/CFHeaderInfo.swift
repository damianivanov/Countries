//
//  CFHeaderInfo.swift
//  Countries
//
//  Created by Damian Ivanov on 8.01.24.
//

import UIKit

class CFHeaderInfo: UIViewController {
    
    var country: Country!
    
    var flagImageView = CFCountryFlag(frame: .zero)
    var countryName = CFTitleLabel(textAlignment: .left, fontSize: 30, weight: .heavy)
    
    var locationImageView = UIImageView()
    var capitalLabel = CFTitleLabel(textAlignment: .left, fontSize: 20, weight: .regular)
    
    var populationImageVIew = UIImageView()
    var populationLabel = CFTitleLabel(textAlignment: .left, fontSize: 20, weight: .regular)
    
    var favoriteIconImageView = UIImageView()

    var isFavorited: Bool {
        return FavoritesManager.isAlredyFavorited(country: CountryShort(flags: country.flags, name: country.name))
    }
    
    
    let favoriteIconString: String = "star"
    let favoriteFillIconString: String = "star.fill"
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        layoutUI()
        configureUI()
        
    }

    init(country: Country) {
        super.init(nibName: nil, bundle: nil)
        self.country = country
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews(){
        view.addSubviews(flagImageView,
                         favoriteIconImageView,
                         countryName,
                         locationImageView,
                         capitalLabel,
                         populationLabel,
                         populationImageVIew)
        
        view.tamicFalse()
    }
    
    func layoutUI(){
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding),
            flagImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            flagImageView.widthAnchor.constraint(equalToConstant: 120),
            flagImageView.heightAnchor.constraint(equalToConstant: 90),

            countryName.topAnchor.constraint(equalTo: flagImageView.topAnchor),
            countryName.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: Constants.padding),
            countryName.widthAnchor.constraint(equalToConstant: 180),
            countryName.heightAnchor.constraint(equalToConstant: Constants.labelHeight*2),
            
            favoriteIconImageView.centerYAnchor.constraint(equalTo: countryName.centerYAnchor),
            favoriteIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding*2),
            favoriteIconImageView.heightAnchor.constraint(equalToConstant: 25),
            favoriteIconImageView.widthAnchor.constraint(equalToConstant: 30),
        
            locationImageView.bottomAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: -Constants.padding),
            locationImageView.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: Constants.padding),
            locationImageView.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            locationImageView.widthAnchor.constraint(equalToConstant: Constants.labelHeight),
            
            capitalLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor),
            capitalLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: Constants.padding),
            capitalLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            capitalLabel.widthAnchor.constraint(equalToConstant: 100),
            
            populationLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor),
            populationLabel.trailingAnchor.constraint(equalTo: favoriteIconImageView.trailingAnchor),
            populationLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            populationLabel.widthAnchor.constraint(equalToConstant: 70),
            
            populationImageVIew.topAnchor.constraint(equalTo: populationLabel.topAnchor),
            populationImageVIew.trailingAnchor.constraint(equalTo: populationLabel.leadingAnchor),
            populationImageVIew.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            populationImageVIew.widthAnchor.constraint(equalToConstant: Constants.labelHeight),
        ])
        
        
    }

    func configureUI(){
        
        flagImageView.downloadFlag(urlString: country.flags.png)
        countryName.text = country.name.common
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationImageView.tintColor = .systemBlue
        
        capitalLabel.text = country.capital?.first ?? ""
        capitalLabel.tintColor = .secondaryLabel
        
        populationImageVIew.image = UIImage(systemName: "person.2.fill")
        populationImageVIew.tintColor = .secondaryLabel
        
        favoriteIconImageView.image =  isFavorited ? UIImage(systemName: favoriteFillIconString) : UIImage(systemName: favoriteIconString)
        
        favoriteIconImageView.tintColor = .systemYellow
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(favorited))
        favoriteIconImageView.addGestureRecognizer(tap)
        favoriteIconImageView.isUserInteractionEnabled = true
        
        if #available(iOS 15.0, *) {
            populationLabel.text = country.population.formatted(.number.locale(.init(identifier: "fr_FR")))
        } else {
            let fmt = NumberFormatter()
            fmt.numberStyle = .decimal
            populationLabel.text = fmt.string(from: country.population as NSNumber )
        }

        populationLabel.tintColor = .secondaryLabel
    }
    
    @objc func favorited() {
        let favoriteCountry = CountryShort(flags: country.flags, name: country.name)
        if isFavorited{
            FavoritesManager.update(country: favoriteCountry, actionType: .remove) {[weak self] error in
                guard let self = self else {return}
                guard error != nil else {
                    self.favoriteIconImageView.image = UIImage(systemName: favoriteIconString)
                    return
                }
            }
        } else {
            FavoritesManager.update(country: favoriteCountry, actionType: .add) {[weak self] error in
                guard let self = self else {return}
                guard error != nil else {
                    self.favoriteIconImageView.image = UIImage(systemName: favoriteFillIconString)
                    return
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)

    }
}
