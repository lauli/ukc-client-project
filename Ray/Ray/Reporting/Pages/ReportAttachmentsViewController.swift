//
//  ReportAttachmentsViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Photos
import UIKit

class ReportAttachmentsViewController: ReportPageViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var second: UIImageView!
    @IBOutlet weak var third: UIImageView!
    @IBOutlet weak var fourth: UIImageView!
    
    private var alreadyOverFourAttachemnts: Bool {
        return first.image != nil && second.image != nil && third.image != nil && fourth.image != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        sendButton.backgroundColor = .princetonOrange
        sendButton.layer.cornerRadius = 5
        
        addButton.backgroundColor = .white
        addButton.setTitleColor(.weldonBlue, for: .normal)
        addButton.layer.borderColor = UIColor.weldonBlue.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 5
        
        first.layer.cornerRadius = first.frame.size.width / 2 
        second.layer.cornerRadius = second.frame.size.width / 2
        third.layer.cornerRadius = third.frame.size.width / 2
        fourth.layer.cornerRadius = fourth.frame.size.width / 2
    }
    

    @IBAction func sendReport(_ sender: Any) {
        
    }
    
    @IBAction func addAttachment(_ sender: Any) {
        
        if alreadyOverFourAttachemnts {
            // TODO: inform user that they can only upload 4
            return
        }
        
        AttachmentsHandler.shared.showActionSheet(currentVC: self)
        
        AttachmentsHandler.shared.imagePickedBlock = { image in
            
            if self.first.image == nil {
                self.first.image = image
                self.first.maskCircle(anyImage: image)
                
            } else if self.second.image == nil {
                self.second.image = image
                self.second.maskCircle(anyImage: image)
                
            } else if self.third.image == nil {
                self.third.image = image
                self.third.maskCircle(anyImage: image)
                
            } else if self.fourth.image == nil {
                self.fourth.image = image
                self.fourth.maskCircle(anyImage: image)

            }
            print("IMAGE")
        }
        
        AttachmentsHandler.shared.videoPickedBlock = { url in
            print("VIDEO")
        }
    }
}

