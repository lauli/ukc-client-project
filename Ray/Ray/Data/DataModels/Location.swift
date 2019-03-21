//
//  Location.swift
//  Ray
//
//  Created by Laureen Schausberger on 21.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class Location {
    let building, floor, room: String
    
    init(building: String, floor: String, room: String) {
        self.building = building
        self.floor = floor
        self.room = room
    }
    
    func toString() -> String {
        return building + ", " + floor + ", " + room
    }
}
