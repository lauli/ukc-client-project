//
//  ReportUserViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 19.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportUserViewController: ReportPageViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var viewUserDifferent: UIView!
    
    @IBOutlet weak var differentName: UITextField!
    @IBOutlet weak var differentPhone: UITextField!
    @IBOutlet weak var differentEmail: UITextField!
    
    @IBOutlet weak var differentConsentLabel: UILabel!
    @IBOutlet weak var consentSwitch: UISwitch!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var elseButton: UIButton!
    
    private var viewModel: ReportingViewModel!

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
        
        elseButton.backgroundColor = .white
        elseButton.setTitleColor(.weldonBlue, for: .normal)
        elseButton.layer.borderColor = UIColor.weldonBlue.cgColor
        elseButton.layer.borderWidth = 1
        elseButton.layer.cornerRadius = 5
        
        // hidden view - report for someone else
        viewUserDifferent.isHidden = true
        consentSwitch.onTintColor = .princetonOrange
        consentSwitch.isOn = false
        differentName.changeTo(color: .charcoal, placeholderText: "Alexander McKenzie")
        differentPhone.changeTo(color: .charcoal, placeholderText: "+44 7220 2345678")
        differentEmail.changeTo(color: .charcoal, placeholderText: "acm1234@kent.ac.uk")
        
        differentConsentLabel.numberOfLines = 0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    private func setupUserDefaults() {
        if viewModel.user == nil {
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if let user = self.viewModel.user {
                    self.nameLabel.text = user.name
                    self.phoneLabel.text = user.phone
                    self.emailLabel.text = user.email
                    timer.invalidate()
                }
            }
            
        } else {
            nameLabel.text = viewModel.user?.name
            phoneLabel.text = viewModel.user?.phone
            emailLabel.text = viewModel.user?.email
        }
    }
    
    private func setUserInfoColorTo(_ color: UIColor){
        nameLabel.textColor = color
        phoneLabel.textColor = color
        emailLabel.textColor = color
    }
    
    private func disableNextButton(_ disable: Bool) {
        nextButton.isEnabled = !disable
        nextButton.backgroundColor = disable ? .princetonOrangeLight : .princetonOrange
    }
    
    @IBAction func nextPage(_ sender: Any) {
        delegate?.nextPage()
    }
    
    @IBAction func reportForSomeoneElse(_ sender: Any) {
        if viewUserDifferent.isHidden {
            viewUserDifferent.isHidden = false
            setUserInfoColorTo(.gray)
            disableNextButton(consentSwitch.isOn ? false : true)
            elseButton.setTitle("Report for Yourself", for: .normal)
        } else {
            viewUserDifferent.isHidden = true
            setUserInfoColorTo(.black)
            disableNextButton(false)
            elseButton.setTitle("Report for Someone Else", for: .normal)
        }
    }
    
    @IBAction func consentSwitch(_ sender: UISwitch) {
        disableNextButton(!sender.isOn)
    }
    
}
