//
//  DetailsVC.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit
import MapKit

@MainActor
class DetailsVC: UIViewController, UIScrollViewDelegate {

    var countryName: String!
    var country: Country!
    var countryShort: CountryShort?
    var headerView = UIView()
    var photosView = UIView()
    var countryInfo = UITextView()
    var mapsButtons = UIView()
    var countryInfoSentences = 3

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

    @objc private func dismissVC() {
        dismiss(animated: true)
    }

    @objc private func cancelVC() {
        dismiss(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }

    private func layoutUI() {
        view.addSubviews(headerView, photosView, countryInfo, mapsButtons)
        view.tamicFalse()
        let height = UIScreen.main.bounds.height < 800 ? Constants.heightScrollViewItemSM : Constants.heightScrollViewItem

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
            photosView.heightAnchor.constraint(equalToConstant: height),

            countryInfo.topAnchor.constraint(equalTo: photosView.bottomAnchor, constant: Constants.padding),
            countryInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            countryInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            //            countryInfo.heightAnchor.constraint(equalToConstant: Constants.viewHeight*2),

            mapsButtons.topAnchor.constraint(equalTo: countryInfo.bottomAnchor, constant: Constants.padding),
            mapsButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            mapsButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            mapsButtons.heightAnchor.constraint(equalToConstant: Constants.buttonHeight + 2*Constants.padding)
            //            mapsButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.padding)

        ])

    }

    private func configureUILabel() {
        countryInfo.textColor = .secondaryLabel
        countryInfo.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        countryInfo.backgroundColor = .systemBackground
        countryInfo.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        countryInfo.isEditable = false
        countryInfo.showsVerticalScrollIndicator = false
    }

    private func add(childVC: UIViewController, to containerView: UIView) {
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
        Task {
            do {
                let country = try await NetworkManager.shared.getCountry(country: countryName)
                guard let country = country?.first else {return}
                add(childVC: CFHeaderInfo(country: country), to: self.headerView)
                add(childVC: CFMapsButtons(country: country), to: self.mapsButtons)
            } catch {
                if let cfError = error as? CFError {
                    presentCFAlertOnMainThread(title: Messages.somethingWentWrong, 
                                               bodyMessage: cfError.rawValue, buttonText: Messages.okMessage)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func loadScrollView() {
        DispatchQueue.main.async {
            self.add(childVC: CFScrollableView(countryName: self.countryName), to: self.photosView)
            self.photosView.tag = 10
        }
    }

    private func loadCountryInfo() {
        Task {
            do {
                let responseQuery = try await NetworkManager.shared.getCountryDescription(country: countryName)
                updateUI(responseQuery)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func updateUI(_ response: QueryResponse) {
        guard let longInfo = response.query.pages.first?.value.extract else {return}
        DispatchQueue.main.async {
            let text = Utils.shared.reduceCountryInfo(longInfo: longInfo, sentencesCount: self.countryInfoSentences)
            self.countryInfo.text = text
            NSLayoutConstraint.activate([
                self.countryInfo.heightAnchor.constraint(equalToConstant: self.countryInfo.contentSize.height)
            ])
            self.countryInfo.sizeToFit()
        }
    }
}
