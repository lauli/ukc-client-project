//
//  Date+Extension.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

extension Date {
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
}
