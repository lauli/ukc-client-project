//
//  UITextFieldExtension.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

extension UITextField {
    
    func changeTo(color: UIColor, placeholderText: String) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension UITextView {
    
    func changeTo(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.textColor = .lightGray
    }
}
