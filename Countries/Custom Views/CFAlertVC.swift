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
    let bodyLabel = CFBodyLabel(textAlignment: .center)
    let button = CFButton(backgroundColor: .systemRed, title: "Ok")
    
    var alertTitle: String?
    var bodyMessage: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
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
        configureContainerView()
        configureTitleLabel()
        configureButton()
        configureBodyLabel()
        
    }
    
    func configureContainerView(){
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            containerView.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    
    func configureTitleLabel(){
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureButton(){
        containerView.addSubview(button)
        button.setTitle(buttonTitle ?? "OK", for: .normal)
        button.addTarget(self, action: #selector(dissmisVC),for:.touchUpInside)
        
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    
    func configureBodyLabel(){
        containerView.addSubview(bodyLabel)
        bodyLabel.text = bodyMessage ?? "Something went wrong"
        bodyLabel.numberOfLines = 5
        bodyLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
        
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            bodyLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10)
        
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != containerView {
            dismiss(animated: true)
        }
    }


    
    @objc func dissmisVC() {
        dismiss(animated: true)
    }
}
