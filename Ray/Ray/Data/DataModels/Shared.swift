//
//  Public.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 15/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class Shared {
    var reports: [Report]?
    
    init(reports: [Report]? = nil) {
        self.reports = reports
    }
}
