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
    var cause : Cause? = nil
    var viewControllerIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        let startVC = viewControllers[viewControllerIndex]
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
    
    func addViewControllers(){
        let firstIntroViewController = FirstIntroViewController(nibName: "FirstIntroViewController", bundle: nil)
        let secondIntroViewController = SecondIntroViewController(nibName: "SecondIntroViewController", bundle: nil)
        
        viewControllers = [firstIntroViewController,secondIntroViewController];
        
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
                self.viewControllerIndex = index
                self.segmentControl.selectedIndex = index
            }
        }
    }
    
    func segmentControlDidChange() {
        self.viewControllerIndex = self.viewControllerIndex == 0 ? 1 : 0
        let animationDirection : UIPageViewControllerNavigationDirection = self.viewControllerIndex == 0 ? .Reverse: .Forward
        let vc = viewControllers [viewControllerIndex]
        self.pageViewController.setViewControllers([vc], direction: animationDirection, animated: true, completion: nil)
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