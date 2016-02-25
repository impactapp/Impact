//
//  DonateViewController.swift
//  Impact
//
//  Created by Phillip Ou on 2/15/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DonationCardViewDelegate, AlertViewControllerDelegate, UITextFieldDelegate {
    let donateCardViewHeight = CGFloat(225)
    let statusBarHeight = CGFloat(20)
    let cellIdentifier = "DonateTableViewCell"
    let rowHeight = CGFloat(61)
    let titlesArray = ["Flat Donation", "Monthly Maximum", "Automatic Donations"]
    let detailsArray = ["Make a one-time flat donation to the cause of your choice.", "Manage a maximum amount you want to donate per month.", "Have your round ups automatically donated on every purchase"]
    var amountTextField:UITextField!
    var currentCause:String!
    var donationCard:DonationCardView!
    
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
        self.amountTextField = donationCardView.amountTextField
        self.amountTextField.delegate = self
        footer.addSubview(donationCardView)
        donationCardView.frame = CGRectMake(inset,20,cardViewWidth,donateCardViewHeight)
        donationCardView.layer.masksToBounds = true
        donationCardView.layer.cornerRadius = 10
        self.donationCard = donationCardView
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            donationCardView.amount = currentUser.pending_contribution_amount
            self.currentCause = currentUser.current_cause_name
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
        cell.titleTextLabel.adjustsFontSizeToFitWidth = true
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
            else if row == 1{
                let mmvc:MonthlyMaximumViewController = MonthlyMaximumViewController();
                self.navigationController?.pushViewController(mmvc, animated: true);
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - DonationCardViewDelegate
    func donateButtonPressed(donationAmount: Int) {
        self.amountTextField.resignFirstResponder()
        self.amountTextField.enabled = false
        let activityIndicator:ActivityIndicator = ActivityIndicator(view: self.view)
        activityIndicator.startAnimating()
        
        let firstMessageString:String =  "You are about to contribute: " + self.amountTextField.text! + " to " + self.currentCause
        let secondMessageString:String =  " click OK to confirm your payment"
        let alertController = UIAlertController(title: "Donate!" , message: firstMessageString + secondMessageString, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            ServerRequest.shared.getCurrentUser  { (currentUser) -> Void in
                self.donationCard.amount = currentUser.pending_contribution_amount
            }
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
            //ADD SUCCESS STUFF - if successful, clear the amount collected (endpoint) and clear text field
            ServerRequest.shared.makeContribution(donationAmount, completion:  { (payment) -> Void in
                activityIndicator.stopAnimating()
                if(payment.id != nil){
                    let alertController = AlertViewController()
                    alertController.delegate = self
                    alertController.setUp(self, title: "Success!", message: "Donated" + self.amountTextField.text! + " to " + self.currentCause, buttonText: "Dismiss")
                    alertController.show()
                }else{
                    let alertController = AlertViewController()
                    alertController.delegate = self
                    alertController.setUp(self, title: "Failure", message: "Donation Failed", buttonText: "Dismiss")
                    alertController.show()
                    
                }
                
            })
        }
    
        alertController.addAction(OKAction)
        alertController.view.tintColor = UIColor.customRed()
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }

        
        
    }
    
    func manageButtonPressed() {
        //Not exactly sure what to do here but will probably select the UI text field
        let newContentOffset = CGPointMake(0, self.tableView.contentSize.height -  self.tableView.bounds.size.height);
        
        self.tableView.setContentOffset(newContentOffset, animated:true);
        self.amountTextField.enabled = true
        self.amountTextField.becomeFirstResponder()
    }
    
    func clearButtonPressed() {
        //clear amount collected and clear the UITextField
        //Warning message
        
        let alertController = UIAlertController(title: "Clear Roundups" , message: "Are you sure you want to clear the roundups you have accumulated?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
            //update monthly max here
            clearPendingContribution()
         
            
        }
        alertController.addAction(OKAction)
        alertController.view.tintColor = UIColor.customRed()
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    func clearPendingContribution(){
        
        
        ServerRequest.shared.clearUserPendingContribution{(currentUser) -> Void in
            activityIndicator.stopAnimating()
            let alertController = AlertViewController()
            alertController.delegate = self
            alertController.setUp(self, title: "Clear", message: "You cleared your roundups", buttonText: "Dismiss")
            alertController.show()
        }
        
        
    }
    
    //TEXT FIELD
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        if((textField.text?.characters.count) == 0){
            self.amountTextField.text = "$"
        }
        return true
        
    }
    
    func popupDismissed() {
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
