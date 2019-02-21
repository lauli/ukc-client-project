//
//  ReportingViewModel.swift
//  Ray
//
//  Created by Laureen Schausberger on 18.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class ReportingViewModel {
    
    private let dataHandler = DataHandler.shared
    
    var user: User? {
        get {
            return dataHandler.user
        }
    }

}
