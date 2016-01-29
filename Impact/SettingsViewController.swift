//
//  SettingsViewController.swift
//  Impact
//
//  Created by Phillip Ou on 1/27/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

enum SettingsSection:String {
    case UserInfo = "User Information"
    case PaymentInfo = "Payment"
    case SecurityInfo = "Security"
}

class SettingsViewController: UIViewController, UITableViewDelegate {
    var dataSource : SettingsTableViewDataSource? = nil
    var user : User? = nil

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = SettingsTableViewDataSource(user: self.user)
        self.tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        disableFloatingHeaders()

        // Do any additional setup after loading the view.
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
    
    func disableFloatingHeaders() {
        let headerHeight = CGFloat(25)
        let tempView = UIView(frame:CGRectMake(0,0,self.tableView.bounds.size.width,headerHeight))
        self.tableView.tableHeaderView = tempView
        self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0)
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
