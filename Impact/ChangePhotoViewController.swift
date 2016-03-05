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

class ChangePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate {

    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var image: UIImageView!
    var user : User? = nil
    var urlString : String? = nil
    
        let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.user = currentUser
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
        
    
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let testFileURL1 = NSURL().URLByAppendingPathComponent("image.png")
        
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
       
        
        let urlString = NSURL(string: "https://ichemepresident.files.wordpress.com/2014/08/impact.jpg")
        let data = NSData(contentsOfURL: urlString!) //make sure your image in this url does exist, otherwise unwrap in a if let check

        let img: UIImage = UIImage(data: data!)!
        let imageData: NSData = UIImagePNGRepresentation(img)!
       
        imageData.writeToURL(testFileURL1, atomically: true)
        
        uploadRequest1.contentType = "image/png"
        // and finally set the body to the local file path
        uploadRequest1.body = testFileURL1;
        uploadRequest1.key =  "image.png"
        uploadRequest1.bucket = "impactapp/test"
        let task = transferManager.upload(uploadRequest1)
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Upload successful")
                
            }
            return nil
        }
        

        
    }

}
