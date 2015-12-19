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
    let cellHeight = CGFloat(60)
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
        self.tableView.registerNib(UINib(nibName: "SearchCauseTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCauseTableViewCell")
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
        let cell:SearchCauseTableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchCauseTableViewCell", forIndexPath: indexPath) as! SearchCauseTableViewCell
        cell.causeNameLabel.text = cause.name
        cell.profileImageView.setImageWithUrl(NSURL(string: cause.profileImageUrl))
        let info = "In partnership with \(cause.organizationName) | \(cause.city),\(cause.state)"
        cell.causeInfoLabel.text = info
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
