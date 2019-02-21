//
//  DataHandler.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation
import Firebase

final class DataHandler {
    
    // singleton
    static let shared: DataHandler = DataHandler()
    
    // firebase ref
    private var reference: DatabaseReference!
    
    // data types
    typealias Success = (Bool) -> ()
    typealias RetrievedUser = (Bool, User?) -> ()
    typealias RetrievedData = (Bool, [String]) -> ()
    
    //
    var user: User
    
    init() {
        reference = Database.database().reference()
        user = User()
        
        fetchUserInformation { success, result in
            if success, let user = result {
                self.user = user
            }
        }
    }
    
    private func fetchUserInformation(completion: @escaping RetrievedUser) {
        
        // TODO: get user id from core data
        
        reference.child("University Of Kent").child("Users").child("12345679890").observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            
            if let id = info?["id"] as? String,
                let email = info?["email"] as? String,
                let name = info?["name"] as? String,
                let phone = info?["phone"] as? String {
                
                var reports: [Report] = []
                if let issues = info?["issues"] as? [String] {
                    for issue in issues {
                        reports.append(Report(id: issue))
                    }
                }
                
                completion(true, User(id: id, name: name, email: email, phone: phone, reports: reports))
                
            } else {
                completion(false, nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false, nil)
        }
    }
    
    func buildings(completion: @escaping RetrievedData){
        var buildings: [String] = []
        
        reference.child("University Of Kent").observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            let allBuildings = info?.allKeys as! [String]
            
            for building in allBuildings {
                let buildingName = String(building.lowercased().capitalized)
                buildings.append(buildingName)
                buildings.sort()
            }
            completion(true, buildings)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false, [])
        }
    }
    
    func floorsFor(building: String, completion: @escaping RetrievedData) {
        var floors: [String] = []
        
        reference.child("University Of Kent").child(building).observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            let allFloors = info?.allKeys as! [String]
            
            for floor in allFloors {
                let floorName = String(floor.lowercased().capitalized)
                floors.append(floorName)
                floors.sort()
            }
            completion(true, floors)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(true, [])
        }
    }
    
    func roomsFor(building: String, floor: String, completion: @escaping RetrievedData) {
        var rooms: [String] = []
        
        reference.child("University Of Kent").child(building).child(floor).observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            let allRooms = info?.allKeys as! [String]
            
            for room in allRooms {
                let roomName = String(room.lowercased().capitalized)
                rooms.append(roomName)
                rooms.sort()
            }
            completion(true, rooms)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(true, [])
        }
    }
    
}
