//
//  DonateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 2/15/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let footer = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,400))
        
        let header = DonationCardView(frame: CGRectMake(0,0,footer.frame.size.width,300))
        footer.addSubview(header)
        self.tableView.tableFooterView = footer
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,400))
//        let header = DonationCardView(frame: CGRectMake(0,100,self.view.frame.size.width,300))
//        footer.addSubview(header)
//        return footer
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
