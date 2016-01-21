//
//  CausePageViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/14/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class CausePageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CustomSegmentControlDelegate, CauseUpdateScrollableDelegate, CauseStoryScrollableDelegate {
    var pageViewController: UIPageViewController!
    var viewControllers : [UIViewController] = []
    @IBOutlet weak var segmentControl: CustomSegmentControl!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var previousBarYOrigin = CGFloat(0)
    var previousScrollViewOffset = CGFloat(0)
    let statusBarHeight = CGFloat(0)
    
    var csvc = CauseStoryViewController(nibName: "CauseStoryViewController", bundle: nil)
    let cuvc = CauseUpdateViewController(nibName: "CauseUpdateViewController", bundle: nil)
    
    var cause : Cause? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarColor(UIColor.customRed(), useWhiteText: true)
        
        cuvc.cause = self.cause
        cuvc.scrollDelegate = self
        
        csvc.cause = self.cause
        csvc.scrollDelegate = self
        
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
        
        if index == viewControllers.count-1 || index == NSNotFound {
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func causeStoryControllerIsScrolling(scrollView: UIScrollView) {
        animateHeaderView(scrollView)
    }
    
    func causeUpdateControllerIsScrolling(scrollView: UIScrollView) {
        animateHeaderView(scrollView)
    }
    
    func animateHeaderView(scrollView:UIScrollView) {
        
        var frame = self.headerView.frame
        let size = self.headerView.frame.size.height
        
        let framePercentageShown = (size + frame.origin.y) / size
        
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousScrollViewOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom //+ statusBarHeight
        var segmentControlFrame = self.segmentControl.frame
        
        let hasReachedBottom = ((scrollOffset + scrollHeight) >= scrollContentSizeHeight && scrollContentSizeHeight > self.view.frame.size.height)
        
        if (scrollOffset <= -scrollView.contentInset.top) {
            frame.origin.y = statusBarHeight
        } else if hasReachedBottom {
            frame.origin.y = -size + 20
        } else {
            frame.origin.y = min(statusBarHeight, max(-size+20, frame.origin.y - scrollDiff));
        }
        
        segmentControlFrame.origin.y = frame.origin.y + frame.size.height
        self.headerView.frame = frame
        self.segmentControl.frame = segmentControlFrame
        self.previousScrollViewOffset = scrollOffset
        
    }
    
    func stoppedScrolling() {
        let frame = self.headerView.frame
        if frame.origin.y < 20 {
            let newY = -(frame.size.height - 21)
            self.transateHeaderTo(newY)
        }
    }
    
    func transateHeaderTo(y:CGFloat) {
        UIView.animateWithDuration(0.2) { () -> Void in
            var frame = self.headerView.frame
            let alpha = CGFloat((frame.origin.y >= y ? 0 : 1))
            frame.origin.y = y
            self.headerView.frame = frame
            self.updateTransparencyHeaderButtons(alpha)
        }
    }
    
    func updateTransparencyHeaderButtons(alpha:CGFloat) {
        self.backButton.alpha = alpha
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