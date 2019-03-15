//
//  NewsFeedViewModel.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 15/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class NewsFeedViewModel {
private(set) var sharedIssue: Shared?

    init() {
        sharedIssue = DataHandler.shared.sharedIssues
        print(sharedIssue!)
    }
    
    
func issueForIndex(_ index: Int) -> Report? {
    return sharedIssue?.reports?[index]
}
}
