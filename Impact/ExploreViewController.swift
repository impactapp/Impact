//
//  ExploreViewController.swift
//  Impact
//
//  Created by Phillip Ou on 10/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController,UITableViewDelegate
,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let cellHeight = CGFloat(140)
    var causes = [1,2,3]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "CausesTableViewCell", bundle: nil), forCellReuseIdentifier: "CausesTableViewCell")
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return causes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CausesTableViewCell", forIndexPath: indexPath)
        return cell
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
