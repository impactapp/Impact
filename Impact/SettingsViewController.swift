//
//  SettingsViewController.swift
//  Impact
//
//  Created by Phillip Ou on 1/27/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import CoreLocation

enum SettingsSection:String {
    case UserInfo = "User Information"
    case PaymentInfo = "Payment"
    case SecurityInfo = "Security"
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateUserInformationDelegate {
    var user : User? = nil
    let userInfoOptions = ["Name", "Email"]
    let paymentInfoOptions = ["Credit Card", "Bank"]
    let securityOptions = ["Location Enabled","Push Notifications","Password","Terms of Service","Help and Support","Logout"]
    let sectionArray : [SettingsSection] = [.UserInfo, .PaymentInfo, .SecurityInfo]
    var sectionHash: [SettingsSection : [String]] = [.UserInfo: [], .PaymentInfo:[], .SecurityInfo:[]]
    var cellIdentifier : String = "SettingsTableViewCell"
    var creditCards : [CreditCard] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        ServerRequest.shared.getCreditCards({ (cards) -> Void in
            self.creditCards = cards
            self.tableView.reloadData()
            },failure: { (errorMessage) -> Void in
                
        })
    }
    
    //MARK: - Table View
    
    func initTableView() {
        self.sectionHash = [.UserInfo: userInfoOptions, .PaymentInfo:paymentInfoOptions, .SecurityInfo:securityOptions]
        self.tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.customDarkGrey()
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        disableFloatingHeaders()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionArray[section]
        let rowsInSection = sectionHash[sectionKey]
        
        return rowsInSection?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return configureCell(tableView, indexPath: indexPath)
    }
    
    func configureCell(tableView:UITableView,indexPath:NSIndexPath) -> SettingsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! SettingsTableViewCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        let section = sectionArray[indexPath.section]
        let array = sectionHash[section]! as [String]
        let cellTitle = array[indexPath.row]
        let shouldHideSwitch = !["Location Enabled", "Push Notifications", "Automatic Payments"].contains(cellTitle)
        cell.cellSwitch.hidden = shouldHideSwitch
        cell.userLabel.hidden = !shouldHideSwitch
        cell.customAccessoryView.hidden = !shouldHideSwitch
        cell.titleLabel.text = cellTitle
        cell.userLabel = configureUserLabel(cell.userLabel, indexPath: indexPath)
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.cellSwitch.on = CLLocationManager.locationServicesEnabled()
                cell.cellSwitch.addTarget(self, action: "changeLocationPreferences:", forControlEvents:.TouchUpInside)
            }
            if indexPath.row == 1 {
                cell.cellSwitch.on = UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
                cell.cellSwitch.addTarget(self, action: "changeRemoteNotificationsSettings:", forControlEvents:.TouchUpInside)
            }
            
        }
        if indexPath.section == 1 {
            if indexPath.row == 1{
                if let user = self.user{
                    if user.needsBankInfo == true{
                        cell.customAccessoryView.image = UIImage(named: "xButton")
                        cell.customAccessoryView.tintColor = UIColor.customRed()
                    }else{
                        cell.customAccessoryView.image = UIImage(named: "Checkmark-50")
                        cell.customAccessoryView.tintColor = UIColor.customRed()

                    }
                }
                
            }
        }
        
        return cell
    }
    
    func configureUserLabel(userLabel:UILabel, indexPath:NSIndexPath) -> UILabel {
        let section = sectionArray[indexPath.section]
        if section == .UserInfo {
            userLabel.hidden = false
            if indexPath.row == 0 {
                userLabel.text = user?.name
            } else if indexPath.row == 1 {
                userLabel.text = user?.email
            }
        } else if section == .PaymentInfo {
            //Credit Card
            if indexPath.row == 0 {
                if let card = self.creditCards.first {
                    userLabel.text = "\(card.brand) *\(card.last4)"
                }
            }
            
        } else {
            userLabel.hidden = true
            if indexPath.row == 0 {
                
                
            }
        }
        return userLabel
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView(frame: CGRectMake(0,0,tableView.frame.size.width,25))
        header.backgroundView = UIView(frame: header.frame)
        header.backgroundView?.backgroundColor = UIColor.whiteColor()
        return header
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        let font = UIFont(name: "AvenirNext-Regular", size: 12.0)!
        header.textLabel!.font = font
        var sectionTitle = ""
        if section == 0 {
            sectionTitle = "User Information"
        } else if section == 1 {
            sectionTitle = "Payment Information"
        } else {
            sectionTitle = "Security"
        }
        
        header.textLabel!.text = sectionTitle
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let eivc = EditInformationViewController()
            eivc.user = self.user
            eivc.editType = indexPath.row == 0 ? .Name : .Email
            eivc.userInfoDelegate = self
            self.navigationController?.pushViewController(eivc, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let ccvc = MyCreditCardsViewController()
                self.navigationController?.pushViewController(ccvc, animated: true)
            }
            if indexPath.row == 1 {
                
                let cbvc = ChooseBankViewController()
                cbvc.enteredFromSettings = true
                self.navigationController?.pushViewController(cbvc, animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 2 {
                let eivc = EditInformationViewController()
                eivc.user = self.user
                eivc.editType = .Password
                eivc.userInfoDelegate = self
                self.navigationController?.pushViewController(eivc, animated: true)
            }
            if indexPath.row == 3 {
                let tosvc = TermsOfServiceViewController()
                tosvc.cameFromSignUp = false
                self.navigationController?.pushViewController(tosvc, animated: true)
            }
            if indexPath.row == 4 {
                let hasvc = HelpAndSupportViewController()
                self.navigationController?.pushViewController(hasvc, animated: true)
            }
            if indexPath.row == 5 {
                logout()
            }
        }
    }
    
    func logout() {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        alertController.view.tintColor = UIColor.customRed()
        
        let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
            let activityIndicator = ActivityIndicator(view: self.view)
            activityIndicator.startCustomAnimation()
            ServerRequest.shared.logout({ (json) -> Void in
                activityIndicator.stopAnimating()
                let initialViewController = InitialScreenViewController()
                self.presentViewController(initialViewController, animated: true, completion: nil)
                },failure: { (errorMessage) -> Void in
                    activityIndicator.stopAnimating()
                    
                    
            })
            
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            
        }
        
        
    }
    
    func disableFloatingHeaders() {
        let headerHeight = CGFloat(25)
        let tempView = UIView(frame:CGRectMake(0,0,self.tableView.bounds.size.width,headerHeight))
        self.tableView.tableHeaderView = tempView
        self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0)
    }
    
    // Update User Info Delegate
    
    func updateUserInfo(user: User) {
        self.user = user
        self.tableView.reloadData()
    }
    
    func changeLocationPreferences(sender:UISwitch) {
        if let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
    
    func changeRemoteNotificationsSettings(sender:UISwitch) {
        if let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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