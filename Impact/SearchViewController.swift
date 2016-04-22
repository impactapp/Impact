//
//  SearchViewController.swift
//  Impact
//
//  Created by Phillip Ou on 12/19/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate{
    func selectedRow(cause:Cause)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet var backButton: UIButton!

    @IBOutlet weak var findYourCauseMessageLabel: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet var initialSearchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    let cellHeight = CGFloat(60)
    var causes:[Cause] = []
    var searchResults:[Cause] = []
    var delegate: SearchViewControllerDelegate? = nil
    var enteredFromDonate = false

    
    let statusBarHeight = CGFloat(0)
    var previousBarYOrigin = CGFloat(0)
    var previousScrollViewOffset = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarColor(UIColor.customRed(), useWhiteText: true)
        initTableView()
        initSearchTextField()
        initInitialSearchView()
        ServerRequest.shared.getAllCauses { (causes) -> Void in
            self.causes = causes
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(enteredFromDonate){
            backButton.hidden = false
        }else{
            backButton.hidden = true
        }
        
    }
    
    func initInitialSearchView() {
        initialSearchView = UINib(nibName: "InitialSearchView", bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        self.view.addSubview(initialSearchView)
        initialSearchView.frame = CGRectMake(0,self.header.frame.size.height+60,self.view.frame.size.width,200)
        if let messageString = findYourCauseMessageLabel.text {
            let text = messageString as NSString
            let attributedString = NSMutableAttributedString(string: messageString)
            if #available(iOS 9.0, *) {
                let range = text.rangeOfString("Impact")
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.customRed(), range: range)
                self.findYourCauseMessageLabel.attributedText = attributedString
            }
        }
    }
    
    //MARK: TextField
    
    func initSearchTextField() {
        self.searchTextField.delegate = self
        self.searchTextField.attributedPlaceholder = NSAttributedString(string:"Search",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.searchTextField.textAlignment = NSTextAlignment.Center
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
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
    
    func dismissKeyboard() {
        self.searchTextField.resignFirstResponder()
    }
    
    //MARK: TableView
    
    func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "SearchCauseTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCauseTableViewCell")
        let tableViewHeader = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, header.frame.size.height - 20))
        tableViewHeader.backgroundColor = UIColor.customDarkGrey() //hacky solution
        self.tableView.tableHeaderView = tableViewHeader
        let tableViewTap = UITapGestureRecognizer(target: self, action: "didTapTableView:")
        self.tableView.addGestureRecognizer(tableViewTap)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cause = self.searchResults[indexPath.row]
        return configureCell(cause, indexPath: indexPath)
    }
    
    //all touches to tableviews go through here because of tap gesture recognizer
    func didTapTableView(recognizer:UIGestureRecognizer) {
        let tapLocation = recognizer.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        let didTouchTableViewCell = indexPath != nil
        
        //if location is on a tableviewcell cancel gesture and let default action take place
        //else dismiss keyboard
        if didTouchTableViewCell {
            recognizer.cancelsTouchesInView = false
        } else {
            dismissKeyboard()
        }
    }
    
    private func configureCell(cause:Cause, indexPath:NSIndexPath) -> SearchCauseTableViewCell {
        let cell:SearchCauseTableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchCauseTableViewCell", forIndexPath: indexPath) as! SearchCauseTableViewCell
        cell.causeNameLabel.text = cause.name
        cell.profileImageView.setImageWithUrl(NSURL(string: cause.profileImageUrl))
        let info = "In partnership with \(cause.organizationName) | \(cause.city), \(cause.state)"
        cell.causeInfoLabel.text = info
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCause = self.searchResults[indexPath.row]

        if(enteredFromDonate){
            if let delegate = self.delegate {
                delegate.selectedRow(selectedCause)
            }
            self.navigationController?.popViewControllerAnimated(true)
            
            
        }else{
            let cpvc = CausePageViewController(nibName: "CausePageViewController", bundle: nil)
            cpvc.cause = selectedCause
            self.navigationController?.pushViewController(cpvc, animated: true)
        }
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
    
    //MARK: Scrolling
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        animateHeaderView(scrollView)
    }
    
    func animateHeaderView(scrollView:UIScrollView) {
        
        var frame = self.header.frame
        let size = self.header.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousScrollViewOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom //+ statusBarHeight
        if (scrollOffset <= -scrollView.contentInset.top) {
            frame.origin.y = statusBarHeight;
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight && scrollContentSizeHeight > self.view.frame.size.height){
            frame.origin.y = -size
        } else {
            frame.origin.y = min(statusBarHeight, max(-size, frame.origin.y - scrollDiff));
        }
        
        self.header.frame = frame
        //self.updateHeaderViewButtons(CGFloat(1) - framePercentageHiden)
        self.previousScrollViewOffset = scrollOffset
        
    }
    
    func stoppedScrolling() {
        let frame = self.header.frame
        if frame.origin.y < 20 {
            let newY = -(frame.size.height - 21)
            self.translateHeaderTo(newY)
        }
    }
    
    func translateHeaderTo(y:CGFloat) {
        UIView.animateWithDuration(0.2) { () -> Void in
            var frame = self.header.frame
            let alpha = CGFloat((frame.origin.y >= y ? 0 : 1))
            frame.origin.y = y
            self.header.frame = frame
            //self.updateHeaderViewButtons(alpha)
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
