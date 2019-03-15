//
//  ReportAttachmentsViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Photos
import UIKit

class ReportAttachmentsViewController: ReportPageViewController, UIGestureRecognizerDelegate {

    @IBOutlet private weak var addButton: UIButton!
    
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBOutlet private weak var first: UIImageView!
    @IBOutlet private weak var second: UIImageView!
    @IBOutlet private weak var third: UIImageView!
    @IBOutlet private weak var fourth: UIImageView!
    
    private var images: [UIImage] = [] {
        didSet {
            first.isUserInteractionEnabled = first.image != nil ? true : false
            second.isUserInteractionEnabled = second.image != nil ? true : false
            third.isUserInteractionEnabled = third.image != nil ? true : false
            fourth.isUserInteractionEnabled = fourth.image != nil ? true : false
        }
    }
    
    private var alreadyOverFourAttachemnts: Bool {
        return first.image != nil && second.image != nil && third.image != nil && fourth.image != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        images = []
        setupLayout()
    }
    
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        
        prevButton.backgroundColor = .princetonOrange
        prevButton.layer.cornerRadius = 5
        
        addButton.backgroundColor = .white
        addButton.setTitleColor(.weldonBlue, for: .normal)
        addButton.layer.borderColor = UIColor.weldonBlue.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 5
        
        first.layer.cornerRadius = first.frame.size.width / 2 
        second.layer.cornerRadius = second.frame.size.width / 2
        third.layer.cornerRadius = third.frame.size.width / 2
        fourth.layer.cornerRadius = fourth.frame.size.width / 2
        
        let tapGestureRecognizerFirst = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizerFirst.delegate = self
        first.accessibilityLabel = "0"
        first.addGestureRecognizer(tapGestureRecognizerFirst)

        let tapGestureRecognizerSecond = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizerSecond.delegate = self
        second.accessibilityLabel = "1"
        second.addGestureRecognizer(tapGestureRecognizerSecond)
        
        let tapGestureRecognizerThird = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizerThird.delegate = self
        third.accessibilityLabel = "2"
        third.addGestureRecognizer(tapGestureRecognizerThird)
        
        let tapGestureRecognizerFourth = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizerFourth.delegate = self
        fourth.accessibilityLabel = "3"
        fourth.addGestureRecognizer(tapGestureRecognizerFourth)
    }
    
    private func deleteImage(_ image: UIImage?) {
        if first.image == image {
            first.image = second.image
            second.image = third.image
            third.image = fourth.image
            fourth.image = nil
            
        } else if second.image == image {
            second.image = third.image
            third.image = fourth.image
            fourth.image = nil
            
        } else if third.image == image {
            third.image = fourth.image
            fourth.image = nil
            
        } else if fourth.image == image {
            fourth.image = nil
        }
        images.removeAll(where: { $0 == image })
    }

    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let alert = UIAlertController(title: "Modify Picture", message: "Would you like to change or delete the picture?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteImage(tappedImage.image)
        }))
        
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
            AttachmentsHandler.shared.showActionSheet(currentVC: self)
            AttachmentsHandler.shared.imagePickedBlock = { image in
                tappedImage.image = image
                
                if let imageIndex = tappedImage.accessibilityLabel {
                    self.images[Int(imageIndex) ?? 0] = image
                    
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showSummary(_ sender: Any) {
        viewModel.attachments = images
        delegate?.nextPage()
    }
    
    @IBAction func addAttachment(_ sender: Any) {
        
        if alreadyOverFourAttachemnts {
            print("too many images saved already")
            let alert = UIAlertController(title: "Maximum Reached", message: "You have reached the maximum number of attachments. If you would like to change one, please click on the attachment to modify it.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
            self.images.append(image)
        }
        
        AttachmentsHandler.shared.videoPickedBlock = { url in
            print("VIDEO")
        }
    }
    
    @IBAction func prevPage(_ sender: Any) {
        delegate?.prevPage()
    }
}

