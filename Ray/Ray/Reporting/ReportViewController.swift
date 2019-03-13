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
}

protocol ReportPageDelegate: class {
    func nextPage()
}
