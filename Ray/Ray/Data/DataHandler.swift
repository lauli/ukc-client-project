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
    typealias DecodedLocations = (Bool, [Location]?) -> ()
    typealias RetrievedData = (Bool, [String]) -> ()
    typealias RetrievedIssues = (Bool, String) -> ()
    typealias RetrievedIssue = (Bool, Shared?) -> ()
    
    // current user
    var user: User?
    
    // current user
    var sharedIssues: Shared?
    
    init() {
        reference = Database.database().reference()
        
        //        fetchUserInformation { success, result in
        //            if success, let user = result {
        //                self.user = user
        //            }
        //        }
    }
    
    func fetchUserInformation(completion: @escaping RetrievedUser) {
        
        // TODO: get user id from core data
        // TODO: make app wait until user is loaded - otherwise login screen
        let id = "2"
        
        reference.child("Company").child("University Of Kent").child("User").child("User ID").child(id).observeSingleEvent(of: .value, with: { result in
            
            guard let info = result.value as? NSDictionary else {
                completion(false, nil)
                return
            }
            
            guard let email = info["email"] as? String,
                let name = info["name"] as? String,
                let phone = info["phone"] as? String else {
                    completion(false, nil)
                    return
            }
            
            var locationArray: [Location] = []
            if let locations = info["saved_locations"] as? [Any] {
                
                for item in locations {
                    guard let location = item as? NSDictionary else {
                        continue
                    }
                    
                    if let loc = self.decodeLocation(location) {
                        locationArray.append(loc)
                    }
                }
            }
            
            if let issueIds = info["issues"] as? [Any] {
                // only add issues to user, when there are issues
                self.decodeIssues(ids: issueIds) { success, result in
                    if success{
                        let user = User(id: id, name: name, email: email, phone: phone,
                                        reports: result, savedLocations: locationArray)
                        self.user = user
                        completion(true, user)
                        
                    } else {
                        completion(false, nil)
                    }
                }
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
            
//            guard let id = issueId as? Int else {
//                continue
//            }
            
            reference.child("Company").child("University Of Kent").child("Issues").child("\(issueId)").observeSingleEvent(of: .value, with: { result in
                
                guard let issue = result.value as? NSDictionary,
                    let report = self.decodeIssue(issue) else {
                        completion(false, nil)
                        return
                }
                reports.append(report)
                
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
    
    private func decodeIssue(_ issue: NSDictionary) -> Report? {
        guard let issuetitle = issue["issue_title"] as? String ,
            let description = issue["description"] as? String,
            let location = issue["location"] as? NSDictionary else {
                return nil
        }
        
        guard let loc = decodeLocation(location) else {
            return nil
        }
        
        return Report(title: issuetitle, description: description, location: loc)
    }
    
    private func decodeLocation(_ location: NSDictionary) -> Location? {
        let loc: Location
        
        if let building = location["building"] as? String,
            let floor = location["floor"] as? String,
            let room = location["room"] as? String {
            
            loc = Location(building: building, floor: floor, room: room)
            
        } else if let lat = location["lat"] as? Double,
            let long = location["long"] as? Double {
            loc = Location(building: "\(lat)", floor: "\(long)", room: "")
            
        } else {
            return nil
        }
        
        return loc
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
    
    
    func fetchReportedIssues(completion: @escaping RetrievedData) {
        var issues: [String] = []
        reference.child("Company").child("University Of Kent").child("Issues").observeSingleEvent(of: .value, with: { result in
            
            for child in result.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                issues.append(key)
            }
            completion(true, issues)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(true, [])
        }
    }
    
    func fetchReportedIssue(issueId: String, completion: @escaping RetrievedIssue) {
        
        var issues: [String] = []
        
        reference.child("Company").child("University Of Kent").child("Issues").child(issueId).observeSingleEvent(of: .value, with: { result in
            
            guard let info = result.value as? NSDictionary else {
                completion(false, nil)
                return
            }
            
            guard let sharedIssue = info["shared"] as? String else {
                    completion(false, nil)
                    return
            }
            
            if sharedIssue == "true" {
                // only add issues to user, when there are issues
                issues.append(issueId)
                self.decodeIssues(ids: issues) { success, result in
                    if success{
                        let sharedIssues = Shared(reports: result)
                        completion(true, sharedIssues)
                    } else {
                        completion(false, nil)
                    }
                }
            }
            
            completion(true, self.sharedIssues)
        
        }) { (error) in
            print(error.localizedDescription)
            completion(false, nil)
        }
    }
}
