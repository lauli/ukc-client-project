//
//  ReportingViewModel.swift
//  Ray
//
//  Created by Laureen Schausberger on 18.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class ReportingViewModel {
    
    private let dataHandler = DataHandler.shared
    
    var user: User? {
        get {
            return dataHandler.user
        }
    }
    
    var location: Location? = nil
    var title: String? = nil
    var description: String? = nil
    var attachments: [UIImage]? = nil
    var isPublic = false

}
