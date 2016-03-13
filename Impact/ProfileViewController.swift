//
//  ProfileViewController.swift
//  Impact
//
//  Created by Phillip Ou on 1/27/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var urlString: String? = nil
    var user : User? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.user = currentUser
            self.configureProfile(self.user)
        }
    }
    
    func configureProfile(user:User?) {
        let singleTap = UITapGestureRecognizer(target: self, action:"tapDetected")
        singleTap.numberOfTapsRequired = 1
        self.profileImageView.userInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(singleTap)
        
        self.nameLabel.text = user?.name
        self.emailLabel.text = user?.email
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        if let currentUser = user {
            
            if currentUser.profile_image_url != nil && currentUser.profile_image_url != ""{
                let urlString = currentUser.profile_image_url
                self.urlString = urlString
                self.profileImageView.setImageWithUrl(NSURL(string:urlString), placeHolderImage: nil)
                
            }else{
                if currentUser.facebook_id != 0 {
                    let facebookURLString = "http://graph.facebook.com/\(currentUser.facebook_id)/picture?type=large"
                    self.urlString = facebookURLString
                    self.profileImageView.setImageWithUrl(NSURL(string: facebookURLString), placeHolderImage: nil)
                    
                    //update url
                    updateURL(facebookURLString)
                    
                    return
                }else{
                    let urlString = "http://www.myoatmeal.com/media/testimonials/pictures/resized/100_100_empty.gif"
                    self.urlString = urlString
                    self.profileImageView.setImageWithUrl(NSURL(string:urlString), placeHolderImage: nil)
                    
                    updateURL(urlString)
                    
                }
            }
            
            
        }
        
    }
    
    
    @IBAction func settingsPressed(sender: AnyObject) {
        let svc = SettingsViewController()
        svc.user = self.user
        self.navigationController?.pushViewController(svc, animated: true)
        
    }
    
    func tapDetected() {
        let cpvc = ChangePhotoViewController()
        cpvc.urlString = self.urlString
        cpvc.user = self.user
        self.navigationController?.pushViewController(cpvc, animated: true)
    }
    
    func updateURL(url:String){
        
        ServerRequest.shared.updateProfileImageURL(url, success: { (successful) -> Void in
            
            }, failure: { (errorMessage) -> Void in
                
        })
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