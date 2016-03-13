//
//  CauseStoryViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/20/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol CauseStoryScrollableDelegate {
    func causeStoryControllerIsScrolling(scrollView:UIScrollView)
}

class CauseStoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, BlogPostTableViewHeaderDelegate {
    
    var scrollDelegate : CauseStoryScrollableDelegate? = nil
    
    let contributeButtonPlusLabelHeight = CGFloat(115)
    
    var summaryHeaderView = BlogPostTableViewHeader(frame:CGRectZero)
    var cause: Cause? = nil
    var joinedLabel : UILabel? = nil
    var joinCauseButton : UIButton? = nil
    var currentCauseId : Int? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let frame = CGRectMake(0,0,self.tableView.frame.size.width,self.tableView.frame.size.height)
        let blogPost = BlogPost()
        blogPost.title = "Test Blog Post"
        blogPost.blog_body =  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "

        let blogPostHeader =    BlogPostTableViewHeader(frame:frame,blogPost:blogPost, cause:self.cause )
        self.summaryHeaderView = blogPostHeader
        self.summaryHeaderView.delegate = self
        self.joinedLabel = blogPostHeader.joinLabel
        self.joinCauseButton = blogPostHeader.joinButton
        //adding 100 for buttons on the bottom
        let newHeight = summaryHeaderView.blogPostLabel.frame.origin.y + summaryHeaderView.blogPostLabel.frame.size.height + self.contributeButtonPlusLabelHeight
        summaryHeaderView.frame.size.height = newHeight
        self.tableView.tableHeaderView = summaryHeaderView
    }
    
    override func viewDidAppear(animated: Bool) {
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.currentCauseId = currentUser.current_cause_id
            if self.cause?.id == self.currentCauseId && self.currentCauseId != nil{
                self.joinCauseButton?.setImage(UIImage(named: "YoureImpacting"), forState: .Normal)
            }else{
                self.joinCauseButton?.setImage(UIImage(named: "ClicktoImpact"), forState: .Normal)

            }
            self.joinedLabel?.text = self.cause?.id == self.currentCauseId ? "You're Contributing!" : "Click to Contribute"
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollDelegate?.causeStoryControllerIsScrolling(scrollView)
    }
    
    
    func joinCauseButtonPressed() {
        if let cause = self.cause {
            if let joinedLabel = self.joinedLabel{
                joinedLabel.text = "You're Contributing!"
            }
            if let joinCauseButton = self.joinCauseButton {
                joinCauseButton.setImage(UIImage(named: "YoureImpacting"), forState: .Normal)
                
            }
            ServerRequest.shared.joinCause(cause, success: { (successful) -> Void in
                }, failure: { (errorMessage) -> Void in
            })
        }
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
