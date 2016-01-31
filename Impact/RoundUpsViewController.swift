//
//  RoundUpsViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 1/19/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class RoundUpsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let statusBarHeight = CGFloat(20)
    let cellIdentifier = "RoundUpsTableViewCell"
    let transactions = [Transaction] = []
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        getTransactions()
        
        let jsonTestString = "{\"_account\": \"xanpD845Qqi0B71qLZKEU5mOLBPKr5hA5oYB6\",\"_id\": \"w4XnLJrmQPCpxrvn6J4Aiw4yqjLqzAcDYNKQ1\",\"amount\": -0.01,\"date\": \"2016-01-27\",\"name\": \"Keep the Change\",\"meta\": {\"location\": {}},\"pending\": false,\"type\": {\"primary\": \"special\"},\"category\": [\"Transfer\",\"Keep the Change Savings Program\"],\"category_id\": \"21008000\",\"score\": {\"location\": {},\"name\": 1}"
        let testTransaction:Transaction = Transaction(fromJson: jsonTestString)
        
        // Do any additional setup after loading the view.
    }
    
    func viewDidAppear(animated: Bool) {
        getTransactions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewController(){
        self.setStatusBarColor(self.headerView.backgroundColor!, useWhiteText: true)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.tableFooterView = UIView() //gets rid of not-needed separators
        
    }
    
    func getTransactions(){
        ServerRequest.shared.getTransactions { (transactions) -> Void in
            self.transactions = transactions
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
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
        let cell : RoundUpsTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RoundUpsTableViewCell
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
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
