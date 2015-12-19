//
//  SearchViewController.swift
//  Impact
//
//  Created by Phillip Ou on 12/19/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var header: UIView!
    @IBOutlet var initialSearchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    let cellHeight = CGFloat(175)
    var causes:[Cause] = []
    var searchResults:[Cause] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchTextField()
        
        ServerRequest.shared.getAllCauses { (causes) -> Void in
            self.causes = causes
            self.tableView.reloadData()
        }
        
        initialSearchView = UINib(nibName: "InitialSearchView", bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        self.view.addSubview(initialSearchView)
        initialSearchView.frame = CGRectMake(0,self.header.frame.size.height+60,self.view.frame.size.width,200)
        
    }
    
    func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "CausesTableViewCell", bundle: nil), forCellReuseIdentifier: "CausesTableViewCell")
        let tableViewHeader = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, header.frame.size.height - 20))
        tableViewHeader.backgroundColor = UIColor.customRed() //hacky solution
        self.tableView.tableHeaderView = tableViewHeader
    }
    
    func initSearchTextField() {
        self.searchTextField.delegate = self
        self.searchTextField.attributedPlaceholder = NSAttributedString(string:"Search",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.searchTextField.textAlignment = NSTextAlignment.Center

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cause = self.searchResults[indexPath.row]
        let cell:CausesTableViewCell = tableView.dequeueReusableCellWithIdentifier("CausesTableViewCell", forIndexPath: indexPath) as! CausesTableViewCell
        cell.causeNameLabel.text = cause.name
        cell.causeImageView.setImageWithUrl(NSURL(string: cause.profileImageUrl))
        cell.organizationImageView.setImageWithUrl(NSURL(string:cause.organizationLogoUrl))
        cell.goalLabel.text = "Seeking $\(cause.goal/100)"
        cell.addressLabel.text = "\(cause.city), \(cause.state)"
        if let goal = cause.goal {
            let amount = cause.currentTotal
            if goal != 0 {
                let percentage = CGFloat(amount)/CGFloat(goal)
                cell.percentageLabel.text = "\(Int(percentage*100))% raised"
                cell.drawPercentageGraph(percentage)
            } else {
                cell.drawPercentageGraph(0)
            }
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !initialSearchView.hidden {
            initialSearchView.hidden = true
        }
        if let searchString = self.searchTextField.text {
            filterContentForSearchText(searchString)
        }

        return true
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {

        let searchString = searchText.lowercaseString
        searchResults = causes.filter {
            $0.name.lowercaseString.containsString(searchString) ||
            $0.organizationName.lowercaseString.containsString(searchString) ||
            $0.city.lowercaseString.containsString(searchString)
        }
        
        tableView.reloadData()
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
