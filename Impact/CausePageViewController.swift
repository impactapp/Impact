//
//  CausePageViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/14/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class CausePageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CustomSegmentControlDelegate {
    var pageViewController: UIPageViewController!
    var viewControllers : [UIViewController] = []
    @IBOutlet weak var segmentControl: CustomSegmentControl!
    
    var csvc = CauseStoryViewController(nibName: "CauseStoryViewController", bundle: nil)
    let cuvc = CauseUpdateViewController(nibName: "CauseUpdateViewController", bundle: nil)
    
    var cause : Cause? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        cuvc.cause = self.cause
        viewControllers = [csvc,cuvc];
        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        let startVC = viewControllers[0]
        let startViewControllers :[UIViewController] = [startVC]
        
        self.pageViewController.setViewControllers(startViewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.segmentControl.delegate = self
        
        self.addChildViewController(self.pageViewController)
        self.pageViewController.view.frame = self.view.frame
        self.pageViewController.view.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.pageViewController.view)
        self.view.sendSubviewToBack(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    // MARK: data source
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = viewControllers.indexOf(viewController)
        
        if index == 0 || index == NSNotFound {
            return nil
        } else {
            return viewControllers[index! - 1]
        }
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = viewControllers.indexOf(viewController)
        
        if index == viewControllers.count-1 || index == NSNotFound
        {
            return nil
            
        }else{
            return viewControllers[index!+1]
        }
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.last {
            if let index = viewControllers.indexOf(viewController) {
                self.segmentControl.selectedIndex = index
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if previousViewControllers.contains(csvc) {
            self.segmentControl.selectedIndex = 1
        } else {
            self.segmentControl.selectedIndex = 0
        }
    }
    
    func segmentControlDidChange() {
        let index = self.segmentControl.selectedIndex
        let vc = viewControllers[index]
        
        let animationDirection : UIPageViewControllerNavigationDirection = index == 0 ? .Reverse: .Forward
        
        self.pageViewController.setViewControllers([vc], direction: animationDirection, animated: true, completion: nil)
        
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}