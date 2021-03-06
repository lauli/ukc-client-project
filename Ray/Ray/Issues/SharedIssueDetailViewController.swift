//
//  SharedIssueDetailViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 18/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SharedIssueDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var attachment1: UIImageView!
    @IBOutlet weak var attachment1ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attachment2: UIImageView!
    @IBOutlet weak var attachment2ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attachment3: UIImageView!
    @IBOutlet weak var attachment3ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attachment4: UIImageView!
    @IBOutlet weak var attachment4ActivityIndicator: UIActivityIndicatorView!
    
    var titleText: String?
    var location: String?
    var date: String?
    var month: String?
    var viewed: String?
    var descriptionText: String?
    var attachment1Text: String?
    var attachment2Text: String?
    var attachment3Text: String?
    var attachment4Text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachment1ActivityIndicator.startAnimating()
        attachment2ActivityIndicator.startAnimating()
        attachment3ActivityIndicator.startAnimating()
        attachment4ActivityIndicator.startAnimating()
        titleLabel.text = titleText
        locationLabel.text = location
        dateLabel.text = date
        monthLabel.text = month
        descriptionLabel.text = descriptionText

        dateLabel.accessibilityLabel = dateLabel.text
        monthLabel.accessibilityLabel = monthLabel.text
        titleLabel.accessibilityLabel = titleLabel.text
        locationLabel.accessibilityLabel = locationLabel.text
        descriptionLabel.accessibilityLabel = descriptionLabel.text
        
        
        if viewed == "true"{
            viewedLabel.text = "\u{2713}\u{2713} Seen"
            viewedLabel.textColor = .princetonOrange
        }else {
            viewedLabel.text = "\u{2713} Delivered"
            viewedLabel.textColor = .darkCerulean
        }
        
        
        downloadImage(urlstr: attachment1Text!, imageView: attachment1, activityIndicator: attachment1ActivityIndicator)
        downloadImage(urlstr: attachment2Text!, imageView: attachment2, activityIndicator: attachment2ActivityIndicator)
        downloadImage(urlstr: attachment3Text!, imageView: attachment3, activityIndicator: attachment3ActivityIndicator)
        downloadImage(urlstr: attachment4Text!, imageView: attachment4, activityIndicator: attachment4ActivityIndicator)
        
    }
    
    func downloadImage(urlstr: String, imageView: UIImageView, activityIndicator: UIActivityIndicatorView) {
        if urlstr == "" {
            activityIndicator.stopAnimating()
            return}
        let url = URL(string: urlstr)!
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                imageView.image = UIImage(data: data)
                imageView.maskCircle(anyImage: imageView.image ?? UIImage(named: "icon-report-outline")!)
            }
        }
        task.resume()
    }

}
