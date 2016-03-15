//
//  ChangePhotoViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 3/4/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

protocol ChangePhotoViewControllerDelegate{
    func successfulUpdate(image:UIImage)
}

class ChangePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, AlertViewControllerDelegate {
    
    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var image: UIImageView!
    var user : User? = nil
    var urlString : String? = nil
    var delegate : ChangePhotoViewControllerDelegate? = nil
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.user = currentUser
        }
        
        if(self.urlString != nil && self.user != nil){
            print(self.urlString)
            self.image.setImageWithUrl(NSURL(string:self.urlString!), placeHolderImage: nil)
        }else{
            let urlString = "http://www.myoatmeal.com/media/testimonials/pictures/resized/100_100_empty.gif"
            self.urlString = urlString
            self.image.setImageWithUrl(NSURL(string:urlString), placeHolderImage: nil)
        }
        
        
        imagePicker.delegate = self
        self.configureProfile()
        helpLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func configureProfile() {
        let singleTap = UITapGestureRecognizer(target: self, action:"tapDetected")
        singleTap.numberOfTapsRequired = 1
        self.image.userInteractionEnabled = true
        self.image.addGestureRecognizer(singleTap)
        
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = self.image.frame.size.width/2
        if(urlString == nil){
            let urlStrings = "http://www.myoatmeal.com/media/testimonials/pictures/resized/100_100_empty.gif"
            self.image.setImageWithUrl(NSURL(string:urlStrings), placeHolderImage: nil)
            return
        }
        self.image.setImageWithUrl(NSURL(string:self.urlString!), placeHolderImage: nil)
        
    }
    
    func tapDetected(){
        imagePicker.allowsEditing = false
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            //Code for launching the camera goes here
            self.imagePicker.sourceType = .Camera
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                image.image = pickedImage
            }
            
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveChangesButtonPressed(sender: AnyObject) {
        
        updatePhoto()
       

        
    }
    
    func updatePhoto(){
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("tmp")
        
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        
        if let img: UIImage = self.image.image {
            let imageData: NSData = UIImagePNGRepresentation(img)!
            
            imageData.writeToURL(testFileURL1, atomically: true)
            if let currentUser = self.user{
                let S3BucketName = "impactapp/profilepicture/" + String(currentUser.id)
                uploadRequest1.contentType = "image/png"
                // and finally set the body to the local file path
                uploadRequest1.body = testFileURL1;
                uploadRequest1.key =  "profileimage.png"
                uploadRequest1.bucket = S3BucketName
                
                let ai = ActivityIndicator(view: self.view)
                
                ai.startCustomAnimation()
                
                
                
                transferManager.upload(uploadRequest1).continueWithBlock { (task) -> AnyObject! in
                    if task.error != nil {
                        let alertController = AlertViewController()
                        alertController.setUp(self, title: "Failure", message: "Unable to update profile image because: \(task.error)", buttonText: "Dismiss")
                        alertController.show()
                        
                    } else {
                        
                        let s3URL = "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest1.key!)"
                        ServerRequest.shared.updateProfileImageURL(s3URL, success: { (successful) -> Void in
                            let alertController = AlertViewController()
                            alertController.setUp(self, title: "Success", message: "You have successfully updated your profile picture", buttonText: "Continue")
                            if let delegate = self.delegate{
                                delegate.successfulUpdate(img)
                            }
                            alertController.delegate = self
                            alertController.show()
                            }, failure: { (errorMessage) -> Void in
                                let alertController = AlertViewController()
                                alertController.setUp(self, title: "Failure", message: "Unable to update profile image", buttonText: "Dismiss")
                                alertController.show()
                        })
                        
                        
                        
                    }
                    ai.stopAnimating()
                    return nil
                }
                
            }else{
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Failure", message: "Unable to update profile image", buttonText: "Dismiss")
                alertController.show()
                
            }
        }
        
    }
    
    func runThisInMainThread(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func popupDismissed() {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}