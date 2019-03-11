//
//  ProfileViewController.swift
//  Ray
//
//  Creat/Users/ksb36/ukc-client-project/Ray/Ray/Profile/ProfileViewController.swifted by Kirsty Samantha Butler on 26/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import PopupDialog

class ProfileViewController: UIViewController, UIPopoverControllerDelegate, UITextFieldDelegate {
    
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
    
    func setAlphaOfBackgroundViews(alpha: CGFloat) {
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        UIView.animate(withDuration: 0.2) {
           statusBarWindow?.alpha = alpha;
           self.view.alpha = alpha;
           self.navigationController?.navigationBar.alpha = alpha;
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func addLocation(_ sender: UIButton) -> Void {
        showDialog()
    }
    
    func showDialog() {
        let title = "Add a new location"
        let message = "Saved locations can be used for quick reporting"

        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
                                    print("Completed")
        }
        
        let buttonOne = CancelButton(title: "CANCEL") {
            //self.label.text = "You cancelled the dialog"
        }
        
        let buttonTwo = DefaultButton(title: "SHAKE", dismissOnTap: false) { [weak popup] in
            popup?.shake()
        }
        
        let buttonThree = DefaultButton(title: "OK") {
            
        }
        
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        self.present(popup, animated: false, completion: nil)
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
