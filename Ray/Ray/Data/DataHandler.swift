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
    typealias RetrievedIssue = (Bool, Shared?) -> ()

    // current user
    var user: User?

    var sharedIssues: Shared?

    init() {
        reference = Database.database().reference()
    }

    func fetchUserInformation(forUserID userID: String, completion: @escaping RetrievedUser) {

        reference.child("Company").child("University Of Kent").child("User").child("User ID").child(userID).observeSingleEvent(of: .value, with: { result in

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
            if let locations = info["saved_locations"] as? [String: Any] {

                for item in locations {
                    guard let location = item.value as? NSDictionary else {
                        continue
                    }

                    if let loc = self.decodeLocation(location) {
                        locationArray.append(loc)
                    }
                }
            }

            if let issueIds = info["issues"] as? [String: String] {
                // only add issues to user, when there are issues
                self.decodeIssues(ids: issueIds) { success, result in
                    if success, let result = result {
                        let user = User(id: userID, name: name, email: email, phone: phone,
                                        reports: result, savedLocations: locationArray)
                        self.user = user
                        completion(true, user)

                    } else {
                        completion(false, nil)
                    }
                }
            } else {
                let user = User(id: userID, name: name, email: email, phone: phone,
                                reports: [], savedLocations: locationArray)
                self.user = user
                completion(true, user)
            }

        }) { (error) in
            print(error.localizedDescription)
            completion(false, nil)
        }
    }

    private func decodeIssues(ids: [String: String], completion: @escaping DecodedReports) {
        var reports: [Report] = []

        print(ids)

        for issueId in ids {
            reference.child("Company").child("University Of Kent").child("Issues").child("\(issueId.value)").observeSingleEvent(of: .value, with: { result in

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
            let day = issue["day"] as? String,
            let month = issue["month"] as? String,
            let viewed = issue["confirmation"] as? String,
            let location = issue["location"] as? NSDictionary,
            let attachment = issue["attachments"] as? NSArray
             else {
                return nil
        }

        guard let loc = decodeLocation(location) else {
            return nil
        }
        
        guard let attachments = decodeAttachments(attachment) else {
            return nil
        }
        
        return Report(title: issuetitle, description: description, day: day, month: month, viewed: viewed, location: loc, attachment: attachments)
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

    private func decodeAttachments(_ attachment: NSArray) -> Attachment? {
        let attachments: Attachment
        
        if attachment.count == 0 {
            attachments = Attachment(attachment1: "", attachment2: "", attachment3: "", attachment4: "")
            
        } else if attachment.count == 1, let attachment1 = attachment[0] as? String {
            attachments = Attachment(attachment1: attachment1, attachment2: "", attachment3: "", attachment4: "")
            
        } else if attachment.count == 2, let attachment1 = attachment[0] as? String, let attachment2 = attachment[1] as? String {
            attachments = Attachment(attachment1: attachment1, attachment2: attachment2, attachment3: "", attachment4: "")
            
        } else if attachment.count == 3, let attachment1 = attachment[0] as? String, let attachment2 = attachment[1] as? String, let attachment3 = attachment[2] as? String {
            attachments = Attachment(attachment1: attachment1, attachment2: attachment2, attachment3: attachment3, attachment4: "")
            
        } else if attachment.count == 4, let attachment1 = attachment[0] as? String, let attachment2 = attachment[1] as? String, let attachment3 = attachment[2] as? String, let attachment4 = attachment[3] as? String {
            attachments = Attachment(attachment1: attachment1, attachment2: attachment2, attachment3: attachment3, attachment4: attachment4)
            
        } else {
            return nil
        }
        
        return attachments
    }
    
    
    func buildings(completion: @escaping RetrievedData) {
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
                issues.append(issueId)
                self.decodeIssues(ids: [issueId: issueId]) { success, result in
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

    func fetchReportedBuildingIssue(issueId: String, buildingName: String, completion: @escaping RetrievedData) {

        var issues: [String] = []

        reference.child("Company").child("University Of Kent").child("Issues").child(issueId).child("location").observeSingleEvent(of: .value, with: { result in

            guard let info = result.value as? NSDictionary else {
                completion(false, [])
                return
            }

            guard let building = info["building"] as? String else {
                completion(false, [])
                return
            }

            if building == buildingName {
                issues.append(issueId)
            }
            completion(true, issues)

        }) { (error) in
            print(error.localizedDescription)
            completion(false, [])
        }
    }

}

// SAVING NEW DATA

extension DataHandler {

    func saveIssue(_ issue: Report) {

        let newReference = self.reference.child("Company").child("University Of Kent").child("Issues").childByAutoId()

        guard let newId = newReference.key else {
            print("DataHandler > Key of new Issue couldn't be found.")
            return
        }
        
        let imageRef = "http://www.efstratiou.info/projects/rayproject/Website/images/" + newId
        var image1 = "", image2 = "", image3 = "", image4 = ""
        if issue.attachment.attachment1 != ""{
            image1 = imageRef + "_1.jpg"
        }
        if issue.attachment.attachment2 != ""{
            image2 = imageRef + "_2.jpg"
        }
        if issue.attachment.attachment3 != ""{
            image3 = imageRef + "_3.jpg"
        }
        if issue.attachment.attachment4 != ""{
            image4 = imageRef + "_4.jpg"
        }
        
        let newIssue = [
            "issue_title": issue.title as NSString,
            "description": issue.description as NSString,
            "day": issue.day as NSString,
            "month": issue.month as NSString,
            "confirmation": "false" as NSString,
            "shared": issue.isPublic.description as NSString,
            "location": [
                "building": issue.location.building as NSString,
                "floor": issue.location.floor as NSString,
                "room": issue.location.room as NSString
                ] as NSDictionary,
            "attachments": [image1 as NSString, image2 as NSString, image3 as NSString, image4 as NSString],
            "website" : "http://www.efstratiou.info/projects/rayproject/Website/#" + newId

            ] as [String : Any]

        // save issue to database
        newReference.setValue(newIssue)

        // save issue id to user in database
        let userReference = reference.child("Company").child("University Of Kent").child("User").child("User ID").child(user?.id ?? "").child("issues").childByAutoId()
        userReference.setValue(newId)

        // add issue to issue array in app
        issue.id = newId
        user?.reports?.append(issue)
    }
}
