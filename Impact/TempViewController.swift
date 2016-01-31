

//
//  TempViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 1/7/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
//        ServerRequest.shared.logout({ (json) -> Void in
//            let tabBarController = TabBarViewController()
//            let nvc = InitialScreenViewController()
//            self.presentViewController(nvc, animated: true, completion: nil)
//            },failure: { (errorMessage) -> Void in
//                let alertViewController = AlertViewController()
//                alertViewController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
//                alertViewController.show()
//        })
        let tabBarController = TabBarViewController()
        let nvc = InitialScreenViewController()
        self.presentViewController(nvc, animated: true, completion: nil)
        
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
