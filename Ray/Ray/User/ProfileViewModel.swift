//
//  ProfileViewModel.swift
//  Ray
//
//  Created by Laureen Schausberger on 13.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class ProfileViewModel {
    
    private let userId: String
    
    private(set) var user: User?
    
    init() {
        UserDefaults.standard.set("1", forKey: "UserId")
        userId = UserDefaults.standard.object(forKey: "UserId") as! String
        // TODO: don't hardcode it once the login is implemented
        user = DataHandler.shared.user
    }
    
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
        return "there are no saved locations atm"
        // TODO: make right when implemented in backend
    }
    
    func issueForIndex(_ index: Int) -> Report? {
        return user?.reports?[index]
    }
    
}
