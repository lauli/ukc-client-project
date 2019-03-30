//
//  Reports.swift
//  Ray
//
//  Created by Laureen Schausberger on 21.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class Report {
    let id: String
    let title: String
    let description: String
    let day: String
    let month: String
    let location: Location
    
    init(id: String = "", title: String, description: String, day: String, month: String, location: Location) {
        self.id = id
        self.title = title
        self.description = description
        self.day = day
        self.month = month
        self.location = location
    }
}
