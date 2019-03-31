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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var attachment1: UIImageView!
    @IBOutlet weak var attachment2: UIImageView!
    @IBOutlet weak var attachment3: UIImageView!
    @IBOutlet weak var attachment4: UIImageView!
    
    var titleText: String?
    var location: String?
    var date: String?
    var month: String?
    var descriptionText: String?
    var attachment1Text: String?
    var attachment2Text: String?
    var attachment3Text: String?
    var attachment4Text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        locationLabel.text = location
        dateLabel.text = date
        monthLabel.text = month
        descriptionLabel.text = descriptionText
        
        downloadImage(urlstr: attachment1Text!, imageView: attachment1)
        downloadImage(urlstr: attachment2Text!, imageView: attachment2)
        downloadImage(urlstr: attachment3Text!, imageView: attachment3)
        downloadImage(urlstr: attachment4Text!, imageView: attachment4)
        
        
    }
    
    func downloadImage(urlstr: String, imageView: UIImageView) {
        if urlstr == "" {
            print("nil")
            return}
        let url = URL(string: urlstr)!
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
                imageView.maskCircle(anyImage: imageView.image ?? UIImage(named: "icon-report-outline")!)
            }
        }
        task.resume()
    }
    

    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
