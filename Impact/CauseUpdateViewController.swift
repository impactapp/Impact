//
//  CauseUpdateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class CauseUpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cause : Cause? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        ServerRequest.shared.getFacebookFriends { (friends) -> Void in
            
        }
        //self.tableView.registerNib(UINib(nibName: "AmountDonatedHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "AmountDonatedHeaderView")
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let cause = self.cause {
            let frame = CGRectMake(0,0,self.tableView.frame.size.width,300)
            let amountDonatedHeaderView = AmountDonatedHeaderView(frame:frame,cause:cause)
            return amountDonatedHeaderView
        }
        return nil
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
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
