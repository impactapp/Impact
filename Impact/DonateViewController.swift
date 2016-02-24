//
//  DonateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 2/15/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DonationCardViewDelegate {
    let donateCardViewHeight = CGFloat(225)
    let statusBarHeight = CGFloat(20)
    let cellIdentifier = "DonateTableViewCell"
    let rowHeight = CGFloat(61)
    let titlesArray = ["Flat Donation", "Monthly Maximum", "Automatic Donations"]
    let detailsArray = ["Make a one-time flat donation to the cause of your choice.", "Manage a maximum amount you want to donate per month.", "Have your round ups automatically donated on every purchase"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.customDarkGrey()
        self.tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.rowHeight = rowHeight
        self.tableView.separatorInset = UIEdgeInsetsZero

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setStatusBarColor(self.headerView.backgroundColor!, useWhiteText: true)

        setUpDonationCardView()
        
    }
    
    private func setUpDonationCardView() {
        let footer = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,420))
        self.tableView.tableFooterView = footer
        let inset = CGFloat(8)
        let cardViewWidth = self.view.frame.size.width - 2*inset
        let donationCardView = DonationCardView(frame: CGRectZero)
        donationCardView.delegate = self
        footer.addSubview(donationCardView)
        donationCardView.frame = CGRectMake(inset,20,cardViewWidth,donateCardViewHeight)
        donationCardView.layer.masksToBounds = true
        donationCardView.layer.cornerRadius = 10
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            donationCardView.amount = currentUser.pending_contribution_amount
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerView.frame.size.height - statusBarHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:DonateTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DonateTableViewCell
        let row = indexPath.row
        
        cell.detailedTextLabel.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        cell.detailedTextLabel.numberOfLines = 0
        cell.detailedTextLabel.text = detailsArray[row]
        cell.titleTextLabel.text = titlesArray[row]
        cell.moneyTextLabel.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = UIColor.clearColor()
        
        switch row{
        case 0:
            cell.cellSwitch.hidden = true
        case 1:
            cell.cellSwitch.hidden = true
        case 2:
            cell.forwardButton.hidden = true
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        default:
            _ = 2
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        if cell != nil {
            if row == 0{
                let fdvc:FlatDonationsViewController = FlatDonationsViewController();
                self.navigationController?.pushViewController(fdvc, animated: true);
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - DonationCardViewDelegate
    func donateButtonPressed(donationAmount: Int) {
        ServerRequest.shared.makeContribution(donationAmount) { (payment) -> Void in
            
        }
    }
    
    func manageButtonPressed() {
        
    }
    
    func clearButtonPressed() {
        
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
