//
//  ReportIssueViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportIssueViewController: ReportPageViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        
        titleTextField.changeTo(color: .charcoal, placeholderText: "Door not closing")
        descriptionTextField.changeTo(color: .charcoal)
        descriptionTextField.setupReportDescription()
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 6, left: 4, bottom: 4, right: 4)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func nextPage(_ sender: Any) {
        delegate?.nextPage()
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
            setupReportDescription()
        }
    }
    
    public func setupReportDescription() {
        self.delegate = self
        self.textColor = .lightGray
        self.text = "Hi!\n\nMy door is not closing properly anymore since Monday afternoon. I think it has something to do with the saftey device on top of the door, that starts beeping when I don't close it properly. Usually when I let my door loose, it shuts automatically without my help. But now it doesn't anymore - it needs my help to do it. \n\nI have attached pictures, and made a video so you can see what is happening. \n\nMany thanks!"
    }
}
