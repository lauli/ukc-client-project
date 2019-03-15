//
//  PopupViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 13/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       commentField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension PopupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    

}
