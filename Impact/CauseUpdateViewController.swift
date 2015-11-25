//
//  CauseUpdateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol CauseUpdateScrollableDelegate {
    func causeUpdateControllerIsScrolling()
}

class CauseUpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cause : Cause? = nil
    var scrollDelegate : CauseUpdateScrollableDelegate? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        ServerRequest.shared.getFacebookFriends { (friends) -> Void in
            
        }
        let frame = CGRectMake(0,0,self.tableView.frame.size.width,150)
        let amountDonatedHeaderView = AmountDonatedHeaderView(frame:frame,cause:cause!) as AmountDonatedHeaderView
        
        self.tableView.tableHeaderView = amountDonatedHeaderView
        self.tableView.tableHeaderView!.frame = frame
        
        //self.tableView.registerNib(UINib(nibName: "AmountDonatedHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "AmountDonatedHeaderView")
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let scrollDelegate = self.scrollDelegate {
            scrollDelegate.causeUpdateControllerIsScrolling()
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
