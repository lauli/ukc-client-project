//
//  PopupViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 13/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class PopupViewController: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PopupViewController", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
