//
//  ReportingViewModel.swift
//  Ray
//
//  Created by Laureen Schausberger on 18.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class ReportingViewModel {
    let user: User?
    
    init() {
        // TODO: fetch user information instead of default
        user = User(id: "1234",
                    name: "Laureen Schausberger",
                    email: "ls691@kent.ac.uk",
                    phone: "+43699 1098 1095")
    }
    
}

final class User {
    let id: String
    var name: String
    var email: String
    var phone: String
    
    init(id: String, name: String, email: String, phone: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}