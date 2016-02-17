//
//  DonateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 2/15/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let donateCardViewHeight = CGFloat(225)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.customDarkGrey()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let footer = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,420))
        self.tableView.tableFooterView = footer
        let inset = CGFloat(8)
        let cardViewWidth = self.view.frame.size.width - 2*inset
        let donationCardView = DonationCardView(frame: CGRectZero)
        footer.addSubview(donationCardView)
        donationCardView.frame = CGRectMake(inset,20,cardViewWidth,donateCardViewHeight)
        donationCardView.layer.masksToBounds = true
        donationCardView.layer.cornerRadius = 10

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
