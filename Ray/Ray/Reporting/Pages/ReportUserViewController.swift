//
//  ReportUserViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 19.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportUserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var viewUserDifferent: UIView!
    
    @IBOutlet weak var differentName: UITextField!
    @IBOutlet weak var differentPhone: UITextField!
    @IBOutlet weak var differentEmail: UITextField!
    
    @IBOutlet weak var differentNameLabel: UILabel!
    @IBOutlet weak var differentPhoneLabel: UILabel!
    @IBOutlet weak var differentEmailLabel: UILabel!
    @IBOutlet weak var differentConsentLabel: UILabel!
    @IBOutlet weak var consentSwitch: UISwitch!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var elseButton: UIButton!
    
    private var viewModel: ReportingViewModel!
    
    weak var delegate: ReportPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReportingViewModel()
        setupLayout()
        setupUserDefaults()
    }
    
    private func setupLayout() {
        // buttons
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        elseButton.backgroundColor = .weldonBlue
        elseButton.layer.cornerRadius = 5
        
        // hidden view - report for someone else
        viewUserDifferent.isHidden = true
        consentSwitch.onTintColor = .princetonOrange
        consentSwitch.isOn = false
//        differentNameLabel.textColor = .princetonOrange
//        differentPhoneLabel.textColor = .princetonOrange
//        differentEmailLabel.textColor = .princetonOrange
        changeTextfieldFor(differentName, color: .charcoal, placeholderText: "Alexander McKenzie")
        changeTextfieldFor(differentPhone, color: .charcoal, placeholderText: "+44 7220 2345678")
        changeTextfieldFor(differentEmail, color: .charcoal, placeholderText: "acm1234@kent.ac.uk")
        
        differentConsentLabel.numberOfLines = 0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    private func changeTextfieldFor(_ textfield: UITextField, color: UIColor, placeholderText: String) {
        textfield.layer.borderColor = color.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.layer.cornerRadius = 5
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                   attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    private func setupUserDefaults() {
        nameLabel.text = viewModel.user?.name
        phoneLabel.text = viewModel.user?.phone
        emailLabel.text = viewModel.user?.email
    }
    
    private func setUserInfoColorTo(_ color: UIColor){
        nameLabel.textColor = color
        phoneLabel.textColor = color
        emailLabel.textColor = color
    }
    
    private func disableNextButton(_ disable: Bool) {
        nextButton.isEnabled = !disable
        nextButton.backgroundColor = disable ? .weldonBlue : .princetonOrange
    }
    
    @IBAction func nextPage(_ sender: Any) {
        delegate?.nextPage()
    }
    
    @IBAction func reportForSomeoneElse(_ sender: Any) {
        if viewUserDifferent.isHidden {
            viewUserDifferent.isHidden = false
            setUserInfoColorTo(.gray)
            disableNextButton(consentSwitch.isOn ? false : true)
        } else {
            viewUserDifferent.isHidden = true
            setUserInfoColorTo(.black)
            disableNextButton(false)
        }
    }
    
    @IBAction func consentSwitch(_ sender: UISwitch) {
        disableNextButton(!sender.isOn)
    }
    
}
