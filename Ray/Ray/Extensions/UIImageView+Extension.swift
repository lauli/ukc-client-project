//
//  UIView+Extension.swift
//  Ray
//
//  Created by Laureen Schausberger on 03.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

extension UIImageView {
    func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.image = anyImage
    }
}
