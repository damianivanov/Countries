//
//  CFAlertVC.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class CFAlertVC: UIViewController {
    
    let containerView = UIView()
    let titleLabel = CFTitleLabel(textAlignment: .center, fontSize: 20)
    let bodyLabel = CFBodyLabel(textAlignment: .center,fontSize: 15)
    let button = CFButton(backgroundColor: .systemRed, title: "Ok")
    
    var alertTitle: String?
    var bodyMessage: String?
    var buttonTitle: String?
    
    
    init(title:String,message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.bodyMessage = message
        self.buttonTitle = buttonTitle
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        addSubviews()
        configureContainerView()
        configureTitleLabel()
        configureButton()
        configureBodyLabel()
        configureConstraints()
        
    }
    func addSubviews(){
        view.addSubviews(containerView,titleLabel,button,bodyLabel)
    }
    
    func configureContainerView(){
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        view.tamicFalse()
    }
    
    func configureConstraints(){
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Constants.alertHeight),
            containerView.widthAnchor.constraint(equalToConstant: Constants.alertWidth),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.alertPadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.alertPadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.alertPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.alertPadding),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.alertPadding),
            bodyLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -Constants.padding),
            
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.alertPadding),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.alertPadding),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.alertPadding),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    func configureTitleLabel(){
        titleLabel.text = alertTitle ?? "Something went wrong"
    }
    
    func configureButton(){
        button.setTitle(buttonTitle ?? "OK", for: .normal)
        button.addTarget(self, action: #selector(dismissVC),for:.touchUpInside)
    }
    
    
    func configureBodyLabel(){
        bodyLabel.text = bodyMessage ?? "Something went wrong"
        bodyLabel.numberOfLines = 5
        bodyLabel.textAlignment = .center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != containerView {
            dismiss(animated: true)
        }
    }
    
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
