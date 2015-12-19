//
//  CauseStoryViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/20/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol CauseStoryScrollableDelegate {
    func causeStoryControllerIsScrolling(scrollView:UIScrollView)
}

class CauseStoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var scrollDelegate : CauseStoryScrollableDelegate? = nil
    
    var amountDonatedHeaderView = BlogPostTableViewHeader(frame:CGRectZero)

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let frame = CGRectMake(0,0,self.tableView.frame.size.width,self.tableView.frame.size.height)
        self.amountDonatedHeaderView = BlogPostTableViewHeader(frame:frame)

        let newHeight = amountDonatedHeaderView.blogPostLabel.frame.origin.y + amountDonatedHeaderView.blogPostLabel.frame.size.height
        amountDonatedHeaderView.frame.size.height = newHeight
        self.tableView.tableHeaderView = amountDonatedHeaderView
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            //hacky solution to fix weird footer
            return UIView(frame: CGRectZero)
        } else {
            let header = UITableViewHeaderFooterView(frame: CGRectMake(0,0,self.view.frame.size.width,44))
            header.backgroundView = UIView(frame: header.frame)
            header.backgroundView?.backgroundColor = UIColor.whiteColor()
            return header
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1 {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel!.text = "Comments"
            let font = UIFont(name: "AvenirNext-Regular", size: 12.0)!
            header.textLabel!.font = font
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollDelegate?.causeStoryControllerIsScrolling(scrollView)
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
