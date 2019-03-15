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
var allIssues = [""]

    init() {
    }
    
    func loadIssues(){
        
        print("test")
//        DataHandler.shared.fetchReportedIssues() { success, issues in
//            if success {
//                self.allIssues = issues
//                for issue in self.allIssues {
//                    DataHandler.shared.fetchReportedIssue(issueId: issue){ success, sharedIssues in
//                        if success {
//                            self.sharedIssue = sharedIssues
//                        }
//                    }
//
//                }
//            }
//        }
    }
    
    
func issueForIndex(_ index: Int) -> Report? {
    return sharedIssue?.reports?[index]
}
}
