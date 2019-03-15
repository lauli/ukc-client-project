//
//  ReportIssueViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportIssueViewController: ReportPageViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextView!
    
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        
        prevButton.backgroundColor = .princetonOrange
        prevButton.layer.cornerRadius = 5
        
        titleTextField.placeholder = "Door not closing"
        descriptionTextField.setupReportDescription()
        descriptionTextField.changeTo(color: UIColor(white: 0.8, alpha: 1))
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 6, left: 4, bottom: 4, right: 4)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    private func hasUserGivenAllInformation() -> Bool {
        if titleTextField.text == nil || titleTextField.text == "" {
            return false
        }
        
        if descriptionTextField.text.contains("Hi!\n\nMy door is not closing properly anymore since Monday afternoon. I think it has something to do with the saftey device on top of the door, that starts beeping when I don't close it properly. Usually when I let my door loose, it shuts automatically without my help. But now it doesn't anymore - it needs my help to do it. \n\nI have attached pictures, and made a video so you can see what is happening. \n\nMany thanks!") {
            return false
        }
        
        return true
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if !hasUserGivenAllInformation() {
            let alert = UIAlertController(title: "Missing Input", message: "Please make sure to give us all the information we need to handle your report properly (title and description).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        viewModel.title = titleTextField.text
        viewModel.description = descriptionTextField.text
        
        delegate?.nextPage()
    }
    
    
    @IBAction func prevPage(_ sender: Any) {
        delegate?.prevPage()
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
