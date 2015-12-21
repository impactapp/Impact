//
//  PreviousImpactsViewController.swift
//  Impact
//
//  Created by Phillip Ou on 12/21/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class PreviousImpactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let statusBarHeight = CGFloat(20)
    var causes : [Cause] = []
    let cellIdentifier = "AccessoryTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarColor(self.headerView.backgroundColor!, useWhiteText: true)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        ServerRequest.shared.getPreviousCauses { (causes) -> Void in
            self.causes = causes
            self.tableView.reloadData()
        }
        super.viewWillAppear(animated)
    }
    
    //MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.causes.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerView.frame.size.height - statusBarHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewHeader = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,self.headerView.frame.size.height - statusBarHeight))
        tableViewHeader.backgroundColor = self.tableView.backgroundColor
        return tableViewHeader
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cause = self.causes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AccessoryTableViewCell
        cell.titleLabel.text = cause.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cause = self.causes[indexPath.row]
        let cpvc = CausePageViewController()
        cpvc.cause = cause
        self.navigationController?.pushViewController(cpvc, animated: true)
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
