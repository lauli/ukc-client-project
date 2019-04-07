//
//  NSMutableData+Extension.swift
//  Ray
//
//  Created by Laureen Schausberger on 02.04.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
