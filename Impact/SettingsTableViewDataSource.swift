//
//  SettingsTableViewDataSource.swift
//  Impact
//
//  Created by Phillip Ou on 1/28/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit


class SettingsTableViewDataSource: NSObject, UITableViewDataSource {
    let userInfoOptions = ["Name", "Email"]
    let paymentInfoOptions = ["Credit Card", "Bank", "Automatic Payments"]
    let securityOptions = ["Location Enabled","Push Notifications","Password","Terms of Service","Help and Support"]
    let sectionArray : [SettingsSection] = [.UserInfo, .PaymentInfo, .SecurityInfo]
    var sectionHash: [SettingsSection : [String]] = [.UserInfo: [], .PaymentInfo:[], .SecurityInfo:[]]
    var cellIdentifier : String = "SettingsTableViewCell"
    var user : User? = nil
    var creditCards : [CreditCard] = []
    
    init(user:User?) {
        self.sectionHash = [.UserInfo: userInfoOptions, .PaymentInfo:paymentInfoOptions, .SecurityInfo:securityOptions]
        super.init()
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
        let section = sectionArray[indexPath.section]
        let array = sectionHash[section]! as [String]
        let cellTitle = array[indexPath.row]
        let shouldHideSwitch = !["Location Enabled", "Push Notifications", "Automatic Payments"].contains(cellTitle)
        cell.cellSwitch.hidden = shouldHideSwitch
        cell.userLabel.hidden = !shouldHideSwitch
        cell.customAccessoryView.hidden = !shouldHideSwitch
        cell.titleLabel.text = cellTitle
        cell.userLabel = configureUserLabel(cell.userLabel, indexPath: indexPath)
        
        return cell
    }
    
    func configureUserLabel(label:UILabel, indexPath:NSIndexPath) -> UILabel {
        let section = sectionArray[indexPath.section]
        if section == .UserInfo {
            label.hidden = false
            if indexPath.row == 0 {
                label.text = user?.name
            } else if indexPath.row == 1 {
                label.text = user?.email
            }
        } else if section == .PaymentInfo {
            
        } else {
            label.hidden = true
        }
        return label

    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        let section = sectionArray[indexPath.section] as SettingsSection
        let items = sectionHash[section]! as [String]
        return items[indexPath.row]
    }

}
