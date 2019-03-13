//
//  ReportUserViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 19.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportSummaryViewController: ReportPageViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    
    @IBOutlet private weak var elseButton: UIButton!
    @IBOutlet private weak var viewUserDifferent: UIStackView!
    @IBOutlet private weak var differentName: UITextField!
    @IBOutlet private weak var differentPhone: UITextField!
    @IBOutlet private weak var differentEmail: UITextField!
    @IBOutlet private weak var differentConsentLabel: UILabel!
    @IBOutlet private weak var consentSwitch: UISwitch!
    
    @IBOutlet private weak var locationLabel: UILabel!
    
    @IBOutlet private weak var reportTitle: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var attachFirst: UIImageView!
    @IBOutlet private weak var attachSecond: UIImageView!
    @IBOutlet private weak var attachThird: UIImageView!
    @IBOutlet private weak var attachFourth: UIImageView!
    
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupUserDefaults()
        setupLocation()
        setupDescription()
        setupAttachments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserDefaults()
        setupLocation()
        setupDescription()
        setupAttachments()
    }
    
    private func setupLayout() {
        // buttons
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        prevButton.backgroundColor = .princetonOrange
        prevButton.layer.cornerRadius = 5
        
        elseButton.backgroundColor = .white
        elseButton.setTitleColor(.princetonOrange, for: .normal)
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
    
    private func setupLocation() {
        locationLabel.text = viewModel.location?.toString()
        
    }
    
    private func setupDescription() {
        reportTitle.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
    
    private func setupAttachments() {
        guard let images = viewModel.attachments else {
            return
        }
        
        if images.count == 4 {
            attachFourth.image = images[3]
        }
        if images.count >= 3 {
            attachThird.image = images[2]
        }
        if images.count >= 2 {
            attachSecond.image = images[1]
        }
        if images.count >= 1 {
            attachFirst.image = images[0]
        }
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
    
    @IBAction func sendReport(_ sender: Any) {
       delegate?.sendReport()
    }
    
    @IBAction func prevPage(_ sender: Any) {
        delegate?.prevPage()
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
