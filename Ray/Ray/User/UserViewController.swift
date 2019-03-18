//
//  UserViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 11.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import PopupDialog

class UserViewController: UIViewController {
    
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
    
   // func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
   //     return UIModalPresentationStyle.none
   // }
    
    @IBAction func addLocation(_ sender: UIButton) {
        showDialog()
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Changes Saved", message: "(Implement saving any changes to details)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func showDialog(animated: Bool = false) {
        
        let popupVC = PopupViewController(nibName: "PopupViewController", bundle: nil)
        
        let popup = PopupDialog(viewController: popupVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
                                
        
        let buttonOne = CancelButton(title: "CANCEL") {
            
        }
        
        let buttonThree = DefaultButton(title: "OK") {
            
            // if fields are empty, popup?.shake()
            
        }
        
        popup.addButtons([buttonOne, buttonThree])
        self.present(popup, animated: animated, completion: nil)
    }
    
    
    @IBAction func ukcBtn(_ sender: UIButton) {
    }
    @IBAction func addBtn(_ sender: UIButton) {
    }
    
    private func setupLayout() {
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
}
