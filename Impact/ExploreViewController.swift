//
//  ExploreViewController.swift
//  Impact
//
//  Created by Phillip Ou on 10/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit
import CoreLocation

class ExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    let statusBarHeight = CGFloat(20)
    let cellHeight = CGFloat(175)
    var causes:[Cause] = []
    var previousBarYOrigin = CGFloat(0)
    var header = HeaderView(view:UIView())
    var previousScrollViewOffset = CGFloat(0)
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarColor(UIColor.customRed(), useWhiteText: true)
        initHeader()
        enableLocationServices()
        self.navigationController?.edgesForExtendedLayout = .None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initTableView()
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
    
    func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "CausesTableViewCell", bundle: nil), forCellReuseIdentifier: "CausesTableViewCell")
        let tableViewHeader = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, header.frame.size.height))
        tableViewHeader.backgroundColor = UIColor.customRed() //hacky solution
        self.tableView.tableHeaderView = tableViewHeader
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return causes.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cause = self.causes[indexPath.row]
        return configureCauseCell(cause, tableView: tableView, indexPath: indexPath)
    }
    
    private func configureCauseCell(cause:Cause,tableView:UITableView, indexPath:NSIndexPath) -> CausesTableViewCell  {
        let cell:CausesTableViewCell = tableView.dequeueReusableCellWithIdentifier("CausesTableViewCell", forIndexPath: indexPath) as! CausesTableViewCell
        cell.causeNameLabel.text = cause.name
        cell.causeImageView.setImageWithUrl(NSURL(string: cause.profileImageUrl))
        cell.organizationImageView.setImageWithUrl(NSURL(string:cause.organizationLogoUrl))
        cell.goalLabel.text = "Seeking $\(cause.goal/100)"
        cell.addressLabel.text = "\(cause.city), \(cause.state)"
        cell.distanceLabel.text = "\(getDistanceFrom(cause)) miles away"
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCause = self.causes[indexPath.row]
        
        let cpvc = CausePageViewController(nibName: "CausePageViewController", bundle: nil)
        cpvc.cause = selectedCause
        self.navigationController?.pushViewController(cpvc, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        animateHeaderView(scrollView)
    }
    
    func animateHeaderView(scrollView:UIScrollView) {

        var frame = self.header.frame
        let size = self.header.frame.size.height
        let framePercentageHiden = ((20 - frame.origin.y) / (frame.size.height - 1))
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
        self.updateHeaderViewButtons(CGFloat(1) - framePercentageHiden)
        self.previousScrollViewOffset = scrollOffset
        
    }

    func stoppedScrolling() {
        let frame = self.header.frame
        if frame.origin.y < 20 {
            let newY = -(frame.size.height - 21)
            self.transateHeaderTo(newY)
        }
    }
    
    func transateHeaderTo(y:CGFloat) {
        UIView.animateWithDuration(0.2) { () -> Void in
            var frame = self.header.frame
            let alpha = CGFloat((frame.origin.y >= y ? 0 : 1))
            frame.origin.y = y
            self.header.frame = frame
            self.updateHeaderViewButtons(alpha)
        }
    }
    
    func updateHeaderViewButtons(alpha:CGFloat) {
        
    }
    
    //MARK: LocationServices
    func enableLocationServices() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0]
    }
    
    private func getDistanceFrom(cause:Cause ) -> Int {
        let causeLocation = CLLocation(latitude: Double(cause.latitude), longitude: Double(cause.longitude))
        let distance = causeLocation.distanceFromLocation(self.userLocation)
        return Int(distance / 1609.344)
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
