//
//  PopUpViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 28/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import PopupDialog

class PopUpViewController: UIViewController, UIPopoverControllerDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var buildingTxt: UITextField!
    @IBOutlet weak var floorTxt: UITextField!
    @IBOutlet weak var roomTxt: UITextField!
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
}


