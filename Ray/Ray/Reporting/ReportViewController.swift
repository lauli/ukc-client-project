//
//  ReportViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 19.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

class ReportViewController: TabmanViewController {
    
    private var viewControllers: [UIViewController] = []
    private var viewModel: ReportingViewModel!
    
    override func viewDidLoad() {
        self.viewModel = ReportingViewModel()
        
        super.viewDidLoad()
        
        self.dataSource = self
        self.transition = Transition(style: .moveIn, duration: 0.3)
        self.navigationOrientation = .horizontal
        self.isScrollEnabled = false
        
        setupPage()
        setupViewControllers()
    }
    
    private func setupPage() {
        navigationItem.title = "New Report"
        tabBarItem = UITabBarItem(title: "Report",
                                  image: UIImage.init(named: "icon-report-outline"),
                                  selectedImage: UIImage.init(named: "icon-report"))
        
        // Setup navigationbar and get rid of navigationbar seperator line
        self.navigationController?.navigationBar.barTintColor = .princetonOrange
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.tintColor = .white
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .extraLight)
        bar.isUserInteractionEnabled = false
        
        bar.layout.transitionStyle = .progressive
        bar.layout.contentMode = .fit
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        bar.indicator.isProgressive = true
        bar.indicator.tintColor = .princetonOrange
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.weight = .light
        bar.indicator.transitionStyle = .snap
        
        bar.buttons.customize { button in
            button.font.withSize(10)
            button.font = UIFont(name: "ShreeDev0714-Bold", size: 12)!
            button.tintColor = .princetonOrange
            button.selectedTintColor = .princetonOrange
        }
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let locationPage = storyboard.instantiateViewController(withIdentifier: "ReportLocationPage") as! ReportLocationViewController
        locationPage.delegate = self
        locationPage.viewModel = viewModel
        viewControllers.append(locationPage)
        
        let issuePage = storyboard.instantiateViewController(withIdentifier: "ReportIssuePage") as! ReportIssueViewController
        issuePage.delegate = self
        issuePage.viewModel = viewModel
        viewControllers.append(issuePage)
        
        let attachmentsPage = storyboard.instantiateViewController(withIdentifier: "ReportAttachmentsPage") as! ReportAttachmentsViewController
        attachmentsPage.delegate = self
        attachmentsPage.viewModel = viewModel
        viewControllers.append(attachmentsPage)
        
        let userPage = storyboard.instantiateViewController(withIdentifier: "ReportUserPage") as! ReportSummaryViewController
        userPage.delegate = self
        userPage.viewModel = viewModel
        viewControllers.append(userPage)
        
        print(viewControllers)
        reloadData()
    }
    
    private func alertIfWeekend() {
        
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: today)
        
        if components.weekday != 7 && components.weekday != 1 {
            // not a weekend - return
            return
        }
        
        let message = "Hi! \n\n I noticed that it's a weekend, so I want to make you aware of the fact that the Estate's office is closed. If you consider your issue an emergency, I recommend reporting it to the Campus Security. \n Campus Security staff are on duty 24 hours per day, 365 days per year and can always be contacted via phone for emergencies: (0122782)3333 and enquiries: (0122782)3300. \n\nIf this isn't an emergency, Estates will be handling your report on Monday. \n\n Have a lovely weekend and stay safe,\n-Ray :)"
        
        let alert = UIAlertController(title: "Weekend Report", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension ReportViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable  {
        switch index {
        case 0:
            return TMBarItem(title: "1. Location")
        case 1:
            return TMBarItem(title: "2. Description")
        case 2:
            return TMBarItem(title: "3. Attachments")
        case 3:
            return TMBarItem(title: "4. Summary")
        default:
            return TMBarItem(title: "")
        }
    }
}

extension ReportViewController: ReportPageDelegate {
    func nextPage() {
        scrollToPage(.next, animated: true)
    }
    
    func prevPage() {
        scrollToPage(.previous, animated: true)
    }
    
    func sendReport() {
        let today = Date()
        
        // TODO: Phoebe make attachments
        let issue = Report(title: viewModel.title ?? "", description: viewModel.description ?? "",
                           day: today.day, month: today.month, viewed: "false",
                           location: viewModel.location ?? Location(building: "", floor: "", room: ""), attachment: Attachment(attachment1: "", attachment2: "", attachment3: "", attachment4: ""),
                           isPublic: viewModel.isPublic)
        DataHandler.shared.saveIssue(issue)
        
        // TODO: implement sending to backend
        uploadImage()
        // TODO: Change filename to be reportid+"_"+String(i)+".jpg" instead of uploaded, cant do until report is sent to backend

        alertIfWeekend()
        scrollToPage(.first, animated: false)
        viewModel = ReportingViewModel()
        viewControllers = []
        setupViewControllers() // reset
        reloadData()
        
        tabBarController?.selectedIndex = 2 // go to profile to see new issue
    }
    
    func uploadImage() {
        
        guard let images = viewModel.attachments, images.count > 0 else {
            return
        }
        
        for i in 1...images.count {
            
            let image = images[i-1]
        
            let filename = "uploaded_"+String(i)+".jpg"
            
            // generate boundary string using a unique per-app string
            let boundary = UUID().uuidString
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            // Set the URLRequest to POST and to the specified URL
            var urlRequest = URLRequest(url: URL(string: "http://www.efstratiou.info/projects/rayproject/Website/upload.php")!)
            urlRequest.httpMethod = "POST"
            
            // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
            // And the boundary is also set here
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            
            // Add the image data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(image.jpegData(compressionQuality: 0.5)!)
            
            // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
            // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            // Send a POST request to the URL, with the data we created earlier
            session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                
                if(error != nil){
                    print("error in uploading")
                    print("\(error!.localizedDescription)")
                }
                
                guard let responseData = responseData else {
                    print("no response data")
                    return
                }
                
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("uploaded to: \(responseString)")
                }
            }).resume()
        }
    }
    
}

protocol ReportPageDelegate: class {
    func nextPage()
    func prevPage()
    func sendReport()
}
