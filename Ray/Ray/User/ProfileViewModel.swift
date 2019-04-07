//
//  ProfileViewModel.swift
//  Ray
//
//  Created by Laureen Schausberger on 13.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//
import Foundation

final class ProfileViewModel {
    
    var user: User? = DataHandler.shared.user
    
    // MARK: - UILabel Texts
    
    func id() -> String {
        return user?.id ?? ""
    }
    
    func nameText() -> String {
        return user?.name ?? ""
    }
    
    func emailText() -> String {
        return user?.email ?? ""
    }
    
    func phoneText() -> String {
        return user?.phone ?? ""
    }
    
    func contactDetailsText() -> String {
        return (user?.email ?? "") + ", " + (user?.phone ?? "")
    }
    
    func savedLocationsText() -> String {
        if let location = user?.savedLocations?.first {
            return "\(location.toString()), etc."
        } else {
            return "No saved locations yet."
        }
    }
    
    func issueForIndex(_ index: Int) -> Report? {
        return user?.reports?[index]
    }
    
}
