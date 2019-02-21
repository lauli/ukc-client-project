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
    typealias DecodedReports = (Bool, [Report]?) -> ()
    typealias RetrievedData = (Bool, [String]) -> ()
    
    // current user 
    var user: User?
    
    init() {
        reference = Database.database().reference()
        
        fetchUserInformation { success, result in
            if success, let user = result {
                self.user = user
            }
        }
    }
    
    private func fetchUserInformation(completion: @escaping RetrievedUser) {
        
        // TODO: get user id from core data
        let id = "12345679890"
        
        reference.child("University Of Kent").child("Users").child(id).observeSingleEvent(of: .value, with: { result in
            
            guard let info = result.value as? NSDictionary else {
                completion(false, nil)
                return
            }
            
            if let email = info["email"] as? String,
                let name = info["name"] as? String,
                let phone = info["phone"] as? String {
                
                self.decodeIssuesFrom(result: info) { success, result in
                    if success{
                        let user = User(id: id, name: name, email: email, phone: phone, reports: result)
                        completion(true, user)
                    } else {
                        completion(false, nil)
                    }
                }
                
            } else {
                completion(false, nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false, nil)
        }
    }
    
    private func decodeIssuesFrom(result: NSDictionary, completion: @escaping DecodedReports) {
        var reports: [Report] = []
        
        guard let array = result["issues"] as? NSArray else {
            completion(false, [])
            return
        }
            
        for issueInfo in array {
            if let issue = issueInfo as? NSDictionary,
                let issuetitle = issue["issue_title"] as? String ,
                let description = issue["description"] as? String,
                let location = issue["location"] as? NSDictionary,
                let building = location["building"] as? String,
                let floor = location["floor"] as? String,
                let room = location["room"] as? String {
                
                print(issuetitle + "  " + description)
                let loc = Location(building: building, floor: floor, room: room)
                reports.append(Report(title: issuetitle, description: description, location: loc))
            }
        }
        completion(true, reports)
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
