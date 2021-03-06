//
//  UserViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 11.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//
import UIKit
import PopupDialog
import Firebase

class UserViewController: UIViewController, UITextFieldDelegate {
    
    var viewModel: ProfileViewModel!
    
    weak var delegate: SavedLocationsUpdateDelegate?
    
    private let uid = UserDefaults.standard.string(forKey: "userID") ?? "1"
    
    //Database ref
    var locationReference: DatabaseReference!
    var userReference: DatabaseReference!
    
    typealias RetrievedUser = (Bool, User?) -> ()
    
    // TextFields
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    // Buttons
    @IBOutlet weak var addLocation: UIButton!
    
    @IBOutlet weak var savedLocationsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        //Database refs
        userReference = Database.database().reference().child("Company").child("University Of Kent").child("User").child("User ID").child(uid)
        locationReference = Database.database().reference().child("Company").child("University Of Kent").child("User").child("User ID").child(uid).child("saved_locations")
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        showDialog()
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        updateDetails()
    }
    
    private func showDialog(animated: Bool = false) {
        let popupVC = PopupViewController(nibName: "PopupViewController", bundle: nil)
        let popup = PopupDialog(viewController: popupVC,
                                buttonAlignment: .horizontal,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        let cancel = CancelButton(title: "CANCEL") {
        }
        
        let confirm = DefaultButton(title: "OK", dismissOnTap: false) { [weak popup] in
            //Checking that none of the fields are empty
            if (popupVC.buildingField.text?.isEmpty)! || (popupVC.floorField.text?.isEmpty)! || (popupVC.roomField.text?.isEmpty)! {
                popup?.shake()
                //Error if empty
                popupVC.errorLabel.text = "None of the fields can be empty. Please enter all location data."
                popupVC.errorLabel.textColor = UIColor.red
                popupVC.errorLabel.numberOfLines = 1
            }
                //Getting data from textFields
            else {
                let newBuilding = popupVC.buildingField.text
                let newFloor = popupVC.floorField.text
                let newRoom = popupVC.roomField.text
                self.locationReference.childByAutoId().setValue(["building":newBuilding, "floor":newFloor, "room": newRoom])
                
                DataHandler.shared.fetchUserInformation(forUserID: self.uid) { success, _ in
                    if success {
                        popupVC.errorLabel.text = "New location added!"
                        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                            popup?.dismiss()
                        }
                        self.delegate?.updateTableView()
                        
                    } else {
                        popupVC.errorLabel.text = "Couldn't load new locations.. "
                    }
                    
                }
                
                
            }
        }
        popup.addButtons([cancel, confirm])
        self.present(popup, animated: animated, completion: nil)
    }
    
    private func setupLayout() {
        updateLabels()
        
        addLocation.backgroundColor = .princetonOrange
        addLocation.layer.cornerRadius = 5
    }
    
    private func updateLabels() {
        nameField.text = viewModel.nameText()
        emailField.text = viewModel.emailText()
        phoneField.text = viewModel.phoneText()
    }
    
    private func updateDetails() {
        //create alert
        let alert = UIAlertController(title: "Changes Saved", message: "", preferredStyle: .alert)
    
        //create OK button
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        
        //present the dialog
        self.present(alert, animated: false, completion: nil)
        
        // if text has been changed, override it as the current value
        if (nameField.text == viewModel.nameText()) {
            
        } else {
            let newName = nameField.text
            userReference.child("name").setValue(newName)
        }
        if (emailField.text == viewModel.emailText()) {
            
        } else {
            let newEmail = emailField.text
            userReference.child("email").setValue(newEmail)
        }
        if (phoneField.text == viewModel.phoneText()) {
           
        } else {
            let newPhone = phoneField.text
            //override value if different
            userReference.child("phone").setValue(newPhone)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let savedLocationTableVC = segue.destination as? SavedLocationsTableViewController {
            delegate = savedLocationTableVC
        }
    }
}
