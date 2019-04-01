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
    let viewed: String
    let location: Location
    let attachment: Attachment
    
    init(id: String = "", title: String, description: String, day: String, month: String, viewed: String, location: Location, attachment: Attachment) {
        self.id = id
        self.title = title
        self.description = description
        self.day = day
        self.month = month
        self.viewed = viewed
        self.location = location
        self.attachment = attachment
    }
}
