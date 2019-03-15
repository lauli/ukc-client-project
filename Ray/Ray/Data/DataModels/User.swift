//
//  User.swift
//  Ray
//
//  Created by Laureen Schausberger on 21.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class User {
    let id: String
    let name: String
    let email: String
    let phone: String
    
    var reports: [Report]?
    var savedLocations: [Location]?
    
    init(id: String = "", name: String = "", email: String = "", phone: String = "", reports: [Report]? = nil, savedLocations: [Location]? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.reports = reports
        self.savedLocations = savedLocations
    }
}
