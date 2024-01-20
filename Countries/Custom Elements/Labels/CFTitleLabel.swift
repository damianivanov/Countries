//
//  CFTitleLabel.swift
//  Countries
//
//  Created by Damian Ivanov on 3.01.24.
//

import UIKit

class CFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.textAlignment = textAlignment
        configure()
    }

    init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textAlignment = textAlignment
        configure()
    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        lineBreakMode = .byTruncatingTail
    }

}
