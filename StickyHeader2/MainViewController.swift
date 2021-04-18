//
//  ContainerViewController.swift
//  StickeyHeaderiOS
//
//  Created by Sowndharya M on 06/01/18.
//  Copyright © 2018 Sowndharya M. All rights reserved.
//

import UIKit

var topViewInitialHeight : CGFloat = 200

let topViewFinalHeight : CGFloat = 0 //navigation hieght

let topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight

class MainViewController: UIViewController {
        
    let tabsCount = 2; #warning ("< 2 causes crash")
        
    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentController: UISegmentedControl!
        
    var pageViewController = UIPageViewController()
        
    var pageCollection = PageCollection()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottom()
    }
    
    @IBAction func tappedSegment(_ sender: Any) {
                
        var direction: UIPageViewController.NavigationDirection
                
        if segmentController.selectedSegmentIndex == 0 {
                
                direction = .reverse
                
            setPageView(toPageWithAtIndex: 0, andNavigationDirection: direction)
            segmentController.selectedSegmentIndex = 0
        } else {
            
            direction = .forward

            setPageView(toPageWithAtIndex: 1, andNavigationDirection: direction)
            segmentController.selectedSegmentIndex = 1
        }
        
    }
    
    func setupBottom() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
            
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController
        firstVC?.innerTableViewScrollDelegate = self
        let page1 = Page(_vc: firstVC!)
        pageCollection.pages.append(page1)
        
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        secondVC?.innerTableViewScrollDelegate = self
        let page2 = Page(_vc: secondVC!)
        pageCollection.pages.append(page2)
        
        let initialPage = 0
        
        pageViewController.setViewControllers([pageCollection.pages[initialPage].vc],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        bottomView.addSubview(pageViewController.view)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
    }
        
    func setPageView(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        
        pageViewController.setViewControllers([pageCollection.pages[index].vc],
                                                  direction: navigationDirection,
                                                  animated: true,
                                                  completion: nil)
    }
    
}

extension MainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        
        guard pageCollection.pages.firstIndex(where: { $0.vc == currentVC }) != nil else { return }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (1..<pageCollection.pages.count).contains(currentViewControllerIndex) {
                                
                return pageCollection.pages[currentViewControllerIndex - 1].vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (0..<(pageCollection.pages.count - 1)).contains(currentViewControllerIndex) {
                                
                return pageCollection.pages[currentViewControllerIndex + 1].vc
            }
        }
        return nil
    }
}

extension MainViewController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        
        return headerViewHeightConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
       
        headerViewHeightConstraint.constant -= scrollDistance
        
       
        if headerViewHeightConstraint.constant > topViewInitialHeight {

            headerViewHeightConstraint.constant = topViewInitialHeight
        }
                 
        if headerViewHeightConstraint.constant < topViewFinalHeight {
            
            headerViewHeightConstraint.constant = topViewFinalHeight
        }
                
        let percentage = (headerViewHeightConstraint.constant) / 100
                
        stickyHeaderView.alpha = percentage
        
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = headerViewHeightConstraint.constant
      
        if topViewHeight <= topViewFinalHeight {
            
            scrollToFinalView()
            
        } else if topViewHeight <= topViewInitialHeight {
            
            switch scrollDirection {
                
            case .Down: scrollToInitialView()
            case .Up: scrollToFinalView()
            
            }
            
        } else {
            
            scrollToInitialView()
        }
    }
    

    
    func scrollToInitialView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewInitialHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewInitialHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollToFinalView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewFinalHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewFinalHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
}
