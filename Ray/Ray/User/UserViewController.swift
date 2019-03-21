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
    var data: DataHandler!
    private var reference: DatabaseReference!
    
    
    typealias RetrievedUser = (Bool, User?) -> ()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var noField: UITextField!
    @IBOutlet weak var chooseLocation: UITextField!
    @IBOutlet weak var chosenLocation: UITextField!
    @IBOutlet weak var addLocation: UIButton!
    @IBOutlet weak var ukc: UIButton!
    @IBOutlet weak var add: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        showDialog()
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var newName: String = ""
        
        //create alert
        let alert = UIAlertController(title: "Changes Saved", message: "(Implement saving any changes to details)", preferredStyle: .alert)
        
        //create OK button
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        
        //present the dialog
        self.present(alert, animated: false, completion: nil)
        
        //data.fetchUserInformation(completion: RetrievedUser)
        // if text has been changed, override it as the current value
        if (nameField.text == viewModel.nameText()) {
            //do nothing
        } else {
            newName = nameField.text ?? ""
            self.reference.child("Company/University Of Kent/User/User ID/\(viewModel.id)/name").setValue(newName)
            alert.message = "NAME CHANGED"
        }
        
        // reference.child("Company").child("University Of Kent").child("User").child("User ID").child(id).observeSingleEvent(of: .value, with: { result in
        
    }
    
    private func showDialog(animated: Bool = false) {
        
        let popupVC = PopupViewController(nibName: "PopupViewController", bundle: nil)
        
        let popup = PopupDialog(viewController: popupVC,
                                buttonAlignment: .horizontal,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
                                
        
        let buttonOne = CancelButton(title: "CANCEL") {
        }
        
        let buttonThree = DefaultButton(title: "OK", dismissOnTap: false) { [weak popup] in
            
            if (popupVC.commentField.text?.isEmpty)! || (popupVC.floorField.text?.isEmpty)! || (popupVC.roomField.text?.isEmpty)! {
                
                popup?.shake()
                
                popupVC.errorLabel.text = "None of the fields can be empty. Please enter all location data."
                popupVC.errorLabel.textColor = UIColor.red
                popupVC.errorLabel.numberOfLines = 2
            }
            else {
                popup?.dismiss()
               // self.view.window!.rootViewController!.dismiss(animated: true, completion: nil)
               // popupVC.dismiss(animated: true, completion: nil)
            }
        }
        
        popup.addButtons([buttonOne, buttonThree])
        self.present(popup, animated: animated, completion: nil)
    }
    
    
    @IBAction func ukcBtn(_ sender: UIButton) {
    }
    @IBAction func addBtn(_ sender: UIButton) {
    }
    
    private func setupLayout() {
        updateLabels()
        
        addLocation.backgroundColor = .princetonOrange
        addLocation.layer.cornerRadius = 5
        
        ukc.backgroundColor = .princetonOrange
        ukc.layer.cornerRadius = 20
        
        add.backgroundColor = .white
        add.setTitleColor(.weldonBlue, for: .normal)
        add.layer.borderColor = UIColor.weldonBlue.cgColor
        add.layer.borderWidth = 1
        add.layer.cornerRadius = 20
    }
    
    private func updateLabels() {
        nameField.text = viewModel.nameText()
        emailField.text = viewModel.emailText()
        noField.text = viewModel.phoneText()
    }
}
