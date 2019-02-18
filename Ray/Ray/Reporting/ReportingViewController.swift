//
//  ReportingViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportingViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewUserDifferent: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var viewPictures: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    
    @IBOutlet weak var userSwitch: UISwitch!
    
    @IBOutlet weak var differentName: UITextField!
    @IBOutlet weak var differentPhone: UITextField!
    @IBOutlet weak var differentEmail: UITextField!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private let viewModel = ReportingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Report a new Issue"
        tabBarItem = UITabBarItem(title: "Report",
                     image: UIImage.init(named: "icon-report-outline"),
                     selectedImage: UIImage.init(named: "icon-report"))
        
        viewUserDifferent.isHidden = true
        userSwitch.onTintColor = .princetonOrange
        
        setupUserDefaults()
        descriptionTextView.setupDescription()
    }
    
    private func setupUserDefaults() {
        userNameLabel.text = viewModel.user?.name
        userPhoneLabel.text = viewModel.user?.phone
        userMailLabel.text = viewModel.user?.email
    }
    
    private func setUserInfoColorTo(_ color: UIColor){
        userNameLabel.textColor = color
        userPhoneLabel.textColor = color
        userMailLabel.textColor = color
    }

    @IBAction func reportForSomeoneElse(_ sender: UISwitch) {
        if sender.isOn {
            viewUserDifferent.isHidden = true
            setUserInfoColorTo(.black)
        } else {
            viewUserDifferent.isHidden = false
            setUserInfoColorTo(.gray)
        }
    }
    
}

extension UITextView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupDescription()
        }
    }
    
    public func setupDescription() {
        self.delegate = self
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.25
        self.textColor = .lightGray
        self.text = "Door not closing\nMy door is not closing properly anymore. I think it has something to do with the saftey device on top of the door, that starts beeping when I don't close it properly. \nI have attached pictures, and made a video so you can see what is happening. \nMany thanks!"
    }
}
