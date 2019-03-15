//
//  SavedLocationsViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 15.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class SavedLocationsViewController: UIPageViewController {
    
    private var pages: [UIViewController] = []
    
    var pageControl = UIPageControl()

    var user: User? {
        get {
            return DataHandler.shared.user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        self.dataSource = self
        self.delegate   = self
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
        configurePageControl()
        
        goToNextPage()
        goToPreviousPage()
    }
    
    private func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: view.bounds.minY,
                                                  width: view.bounds.width,
                                                  height: 50))
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.princetonOrangeLight
        pageControl.pageIndicatorTintColor = UIColor.princetonOrangeLight
        pageControl.currentPageIndicatorTintColor = UIColor.princetonOrange
        view.addSubview(pageControl)
    }
    
    private func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        for location in user?.savedLocations ?? [] {
            let locationPage = storyboard.instantiateViewController(withIdentifier: "SingleSavedLocation") as! SingleSavedLocationViewController
            locationPage.location = location
            pages.append(locationPage)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: pageContentViewController)!
    }
}

extension SavedLocationsViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
}

extension SavedLocationsViewController: UIPageViewControllerDelegate { }

extension SavedLocationsViewController {
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
    
}
