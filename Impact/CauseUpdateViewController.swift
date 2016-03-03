//
//  CauseUpdateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol CauseUpdateScrollableDelegate {
    func causeUpdateControllerIsScrolling(scrollView:UIScrollView)
}

class CauseUpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AmountDonatedHeaderViewCauseDelegate {
    var cause : Cause? = nil
    var scrollDelegate : CauseUpdateScrollableDelegate? = nil
    var blogPosts : [BlogPost] = []
    var contributors : [User] = []
    let updateHeaderHeight : CGFloat = 250
    let userCollectionViewHeight = CGFloat(110)
    var contributorsHeaderView : FriendsCollectionViewHeader = FriendsCollectionViewHeader(frame: CGRectZero)
    var joinCauseButton : UIButton? = nil;
    var currentCauseId : Int? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.customDarkGrey()
        self.tableView.registerNib(UINib(nibName: "AccessoryTableViewCell", bundle: nil), forCellReuseIdentifier: "AccessoryTableViewCell")

        if let cause = self.cause {
            let frame = CGRectMake(0,0,self.tableView.frame.size.width,updateHeaderHeight + 44)
            let amountDonatedHeaderView = AmountDonatedHeaderView(frame:frame,cause:cause) as AmountDonatedHeaderView
            amountDonatedHeaderView.joinCauseDelegate = self
            self.tableView.tableHeaderView = amountDonatedHeaderView
            self.joinCauseButton = amountDonatedHeaderView.joinCauseButton;
            ServerRequest.shared.getCauseBlogPostsAndContributors(cause, success: { (blogPosts, contributors) -> Void in
                self.blogPosts = blogPosts
                self.contributors = contributors
                self.tableView.reloadData()
                let headerFrame = CGRectMake(0,0,self.view.frame.size.width,self.userCollectionViewHeight)
                self.contributorsHeaderView = FriendsCollectionViewHeader(frame: headerFrame, friends: contributors)
                }, failure: { (errorMessage) -> Void in
                    
            })
        }


    }
    
    override func viewWillAppear(animated: Bool) {
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.currentCauseId = currentUser.current_cause_id
            self.joinCauseButton?.selected = self.cause?.id == self.currentCauseId && self.currentCauseId != nil
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return userCollectionViewHeight
        }
        
        return 25
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            //hacky solution to fix weird footer
            return UIView(frame: CGRectZero)
        } else if section == 1 {
            let header = FriendsCollectionViewHeader(frame: CGRectMake(0,0,self.view.frame.size.width,80), friends: self.contributors)
            return header
        } else {
            let header = UITableViewHeaderFooterView(frame: CGRectMake(0,0,self.view.frame.size.width,25))
            header.backgroundView = UIView(frame: header.frame)
            header.backgroundView?.backgroundColor = UIColor.whiteColor()
            return header
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 2 {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel!.text = "Blog Posts"
            let font = UIFont(name: "AvenirNext-Regular", size: 12.0)!
            header.textLabel!.font = font
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return 0
        }
        if section == 1 {
            return 0
        }
        return self.blogPosts.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let blogPost = self.blogPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryTableViewCell", forIndexPath: indexPath) as! AccessoryTableViewCell
        cell.titleLabel.text = blogPost.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let blogPost = self.blogPosts[indexPath.row]
        let cbpvc = CauseBlogPostViewController(nibName:"CauseBlogPostViewController", bundle: nil)
        cbpvc.blogPost = blogPost
        cbpvc.cause = self.cause
        self.navigationController?.pushViewController(cbpvc, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let scrollDelegate = self.scrollDelegate {
            scrollDelegate.causeUpdateControllerIsScrolling(scrollView)
        }
    }
    
    func joinCause() {
        if let cause = self.cause {
            if let joinCauseButton = self.joinCauseButton {
                joinCauseButton.selected = true
            }
            ServerRequest.shared.joinCause(cause, success: { (successful) -> Void in
                }, failure: { (errorMessage) -> Void in
            })
        }
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
