//
//  CauseBlogPostViewController.swift
//  Impact
//
//  Created by Phillip Ou on 1/13/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class CauseBlogPostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var scrollDelegate : CauseStoryScrollableDelegate? = nil
    
    var blogPostHeaderView = BlogPostTableViewHeader(frame:CGRectZero)
    var blogPost : BlogPost? = nil
    var cause : Cause? = nil
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var previousBarYOrigin = CGFloat(0)
    var previousScrollViewOffset = CGFloat(0)
    let statusBarHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let frame = CGRectMake(0,0,self.tableView.frame.size.width,self.tableView.frame.size.height)
        if let blogPost = self.blogPost {
            self.blogPostHeaderView = BlogPostTableViewHeader(frame:frame, blogPost: blogPost, cause: cause)
        }
        
        let newHeight = blogPostHeaderView.blogPostLabel.frame.origin.y + blogPostHeaderView.blogPostLabel.frame.size.height
        blogPostHeaderView.frame.size.height = newHeight
        self.tableView.tableHeaderView = blogPostHeaderView
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        animateHeaderView(scrollView)
    }
    
    // MARK: - Scrollview
    
    func animateHeaderView(scrollView:UIScrollView) {
        
        var frame = self.headerView.frame
        let size = self.headerView.frame.size.height
        
        let framePercentageShown = (size + frame.origin.y) / size
        
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousScrollViewOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom //+ statusBarHeight
        
        let hasReachedBottom = ((scrollOffset + scrollHeight) >= scrollContentSizeHeight && scrollContentSizeHeight > self.view.frame.size.height)
        
        if (scrollOffset <= -scrollView.contentInset.top) {
            frame.origin.y = statusBarHeight
        } else if hasReachedBottom {
            frame.origin.y = -size + 20
        } else {
            frame.origin.y = min(statusBarHeight, max(-size+20, frame.origin.y - scrollDiff));
        }

        self.headerView.frame = frame
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
    }
    
    
    // MARK: - Navigation
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
