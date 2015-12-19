//
//  SearchViewController.swift
//  Impact
//
//  Created by Phillip Ou on 12/19/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var header = HeaderView(view: UIView())

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var causes:[Cause] = []
    var searchResults:[Cause] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
        ServerRequest.shared.getAllCauses { (causes) -> Void in
            self.causes = causes
            self.tableView.reloadData()
        }
    }

    func initHeader() {
        if !self.view.subviews.contains(self.header) {
            self.header = HeaderView(view: self.view)
            self.view.addSubview(self.header)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let searchString = self.searchTextField.text {
            filterContentForSearchText(searchString)
        }

        return true
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchResults = causes.filter { cause in
            return cause.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        print(searchResults)
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
