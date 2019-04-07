//
//  UINavigationBarExtension.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
