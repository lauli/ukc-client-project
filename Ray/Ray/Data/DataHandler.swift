//
//  DataHandler.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation
import Firebase

// public typealiases
typealias Success = (Bool) -> ()

final class DataHandler {
    
    // singleton
    static let shared: DataHandler = DataHandler()
    
    // firebase ref
    private var reference: DatabaseReference!
    
    // data types
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
        let id = "1"
        
        reference.child("Company").child("University Of Kent").child("User").child("User ID").child(id).observeSingleEvent(of: .value, with: { result in
            
            guard let info = result.value as? NSDictionary else {
                completion(false, nil)
                return
            }
            
            if let email = info["email"] as? String,
                let name = info["name"] as? String,
                let phone = info["phone"] as? String,
            let issueIds = info["issues"] as? [Any] {
                
                self.decodeIssues(ids: issueIds) { success, result in
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
    
    private func decodeIssues(ids: [Any], completion: @escaping DecodedReports) {
        var reports: [Report] = []
        
        print(ids)

        for issueId in ids {

            guard let id = issueId as? Int else {
                continue
            }

            reference.child("Company").child("University Of Kent").child("Issues").child("\(id)").observeSingleEvent(of: .value, with: { result in

                guard let issue = result.value as? NSDictionary else {
                    completion(false, nil)
                    return
                }

                guard let issuetitle = issue["issue_title"] as? String ,
                    let description = issue["description"] as? String,
                    let location = issue["location"] as? NSDictionary else {
                        completion(false, nil)
                        return
                }
                
                let loc: Location
                
                if let building = location["building"] as? String,
                    let floor = location["floor"] as? String,
                    let room = location["room"] as? String {

                    loc = Location(building: building, floor: floor, room: room)
                    
                } else if let lat = location["lat"] as? Double,
                let long = location["long"] as? Double {
                    loc = Location(building: "Lat: \(lat)", floor: "Long: \(long)", room: "")
                    
                } else {
                    completion(false, nil)
                    return
                }
                
                reports.append(Report(title: issuetitle, description: description, location: loc))
                
                if reports.count == ids.count {
                    // only end fetching when all issues were fetched
                    completion(true, reports)
                }

            }) { (error) in
                print(error.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    func buildings(completion: @escaping RetrievedData){
        var buildings: [String] = []
        
        reference.child("Company").child("University Of Kent").child("Building").observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            
            guard let allBuildings = info?.allKeys as? [String] else {
                completion(false, [])
                return
            }

            for building in allBuildings {
                let buildingName = String(building.lowercased().capitalized)
                buildings.append(buildingName)
            }
            completion(true, buildings)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false, [])
        }
    }
    
    func floorsFor(building: String, completion: @escaping RetrievedData) {
        var floors: [String] = []
        
        reference.child("Company").child("University Of Kent").child("Building").child(building).child("Floor").observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            
            guard let allFloors = info?.allKeys as? [String] else {
                completion(false, [])
                return
            }
            
            for floor in allFloors {
                let floorName = String(floor.lowercased().capitalized)
                floors.append(floorName)
            }
            completion(true, floors)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(true, [])
        }
    }
    
    func roomsFor(building: String, floor: String, completion: @escaping RetrievedData) {
        var rooms: [String] = []
        
        reference.child("Company").child("University Of Kent").child("Building").child(building).child("Floor").child(floor).child("Room").observeSingleEvent(of: .value, with: { result in
            let info = result.value as? NSDictionary
            
            guard let allRooms = info?.allKeys as? [String] else {
                completion(false, [])
                return
            }
            
            for room in allRooms {
                let roomName = String(room.lowercased().capitalized)
                rooms.append(roomName)
            }
            completion(true, rooms)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(true, [])
        }
    }
    
}
