//
//  PageViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/27/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource {
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var getStartedButton: RoundedButton!
    var pageViewController: UIPageViewController!
    var viewControllers : [UIViewController] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        let startVC = viewControllers[0]
        let startViewControllers :[UIViewController] = [startVC]

        self.pageViewController.setViewControllers(startViewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.dataSource = self
        
        self.addChildViewController(self.pageViewController)
        self.pageViewController.view.frame = self.view.frame
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.didMoveToParentViewController(self)
        
        
        let pageControl = UIPageControl.appearance()
        
        pageControl.pageIndicatorTintColor = UIColor.customRed()
        
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        
        self.view.bringSubviewToFront(getStartedButton)
        getStartedButton.hidden = true
        self.view.bringSubviewToFront(skipButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addViewControllers(){
        let firstIntroViewController = FirstIntroViewController(nibName: "FirstIntroViewController", bundle: nil)
        let secondIntroViewController = SecondIntroViewController(nibName: "SecondIntroViewController", bundle: nil)
        let thirdIntroViewController = ThirdIntroViewController(nibName: "ThirdIntroViewController",bundle: nil)
        let finalIntroViewController = FinalIntroViewController(nibName: "FinalIntroViewController",bundle: nil)
        
        viewControllers = [firstIntroViewController,secondIntroViewController,thirdIntroViewController,finalIntroViewController];
        
    }
    

    
    
    
    // MARK: data source
    
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
        
    {
        let index = viewControllers.indexOf(viewController)
        
        
        
        if index == viewControllers.count-1
        {
            getStartedButton.hidden = false
            skipButton.hidden = true
        }else{
            getStartedButton.hidden = true
            skipButton.hidden = false
        }
        
        if index == 0 || index == NSNotFound
        {
            return nil
            
        }else{
            return viewControllers[index!-1]

        }
       
        
        
        
        
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        
        
        let index = viewControllers.indexOf(viewController)
        
        
        
        if index == viewControllers.count-1
        {
            getStartedButton.hidden = false
            skipButton.hidden = true
        }else{
            getStartedButton.hidden = true
            skipButton.hidden = false
        }
        
        if index == viewControllers.count-1 || index == NSNotFound
            
            
        {
            return nil
            
        }else{
            return viewControllers[index!+1]
            
        }
        
        
        
        
        
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
        
    {
        
        return self.viewControllers.count
        
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
        
    {
        
        return 0
        
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func getStartedButtonPressed(sender: AnyObject) {
        let initialVC = InitialScreenViewController(nibName: "InitialScreenViewController", bundle: nil);
        self.navigationController?.pushViewController(initialVC, animated: true);
        
    }
    
    @IBAction func skipButtonPressed(sender: AnyObject) {
        let initialVC = InitialScreenViewController(nibName: "InitialScreenViewController", bundle: nil);
        self.navigationController?.pushViewController(initialVC, animated: true);
        
        
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
