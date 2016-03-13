//
//  TermsOfServiceViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 3/3/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    var cameFromSignUp : Bool! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if let cameFromSignUp = self.cameFromSignUp{
            if cameFromSignUp {
                self.dismissViewControllerAnimated(true, completion: nil)
            }else{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}
