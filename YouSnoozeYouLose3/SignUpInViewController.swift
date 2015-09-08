//
//  SignUpInViewController.swift
//  YouSnoozeYouLose3
//
//  Created by Tyler hostager on 8/4/15.
//  Copyright © 2015 Tyler hostager. All rights reserved.
//

import UIKit

class SignUpInViewController: UIViewController, UITextFieldDelegate {

    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView;
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var alert: UIAlertController!
    var msgTitle: String! = "";
    var alertMsg: String! = "";
    var submittedUsername: String!
    
    
    let DEFAULT_ACTIVITY_INDICATOR_VISIBILITY: Bool = false;
    let DEFAULT_ACTIVITY_INDICATOR_ACTION: Bool = true;
    
    let DEFAULT_ALERT_ACTION: UIAlertAction = UIAlertAction(
        title: "OK",
        style: UIAlertActionStyle.Cancel,
        handler: nil
    );
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.activityIndicator.center = self.view.center;
        self.activityIndicator.hidesWhenStopped = true;
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        view.addSubview(self.activityIndicator);
        password.delegate = self;
        //preferredStatusBarStyle();
        //setNeedsStatusBarAppearanceUpdate();
        /*
        setActivityIndicatorVisibility(DEFAULT_ACTIVITY_INDICATOR_VISIBILITY);
        setActivityIndicatorVisibility(DEFAULT_ACTIVITY_INDICATOR_VISIBILITY);
        view.addSubview(self.activityIndicator);
        */
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        var username = emailAddress.text;
        var userPassword = password.text;
        //var userEmailAddress = emailAddress.text;
        //userEmailAddress = userEmailAddress?.lowercaseString;
        
        if (username!.utf16.count < 5 || userPassword!.utf16.count < 5) {
            assignMsgTitle("Invalid Login");
            assignAlertMsg("Username and password must be at least four characters long.");
        } else {
            //animateIndicator();
            self.activityIndicator.startAnimating();
            PFUser.logInWithUsernameInBackground(
                username!,
                password: userPassword!,
                block: { (user, error) -> Void in
                    self.activityIndicator.stopAnimating();
                    //self.stopIndicatorAnimations();
                    
                    if (user != nil) {
                        self.assignMsgTitle("Success!");
                        self.assignAlertMsg(
                            "User \"\(username!)\" was successfully logged in."
                        );
                        print("> User succesfully logged in");
                        self.performSegueWithIdentifier(
                            "toTableView",
                            sender: self
                        );
                    } else {
                        self.assignMsgTitle("User Not Found");
                        self.assignAlertMsg(
                            "User \"\(username!)\" is not a registered user. Please try again."
                        );
                        print("> ERROR: Unable to log in user with the given credentials");
                    }
                    
            });
            showUIAlert(
                msgTitle,
                newMessage: alertMsg,
                newStyle: .Alert
            );
        }
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        let alertController = UIAlertController(title: "Agree to the Terms and Conditions",
            message: "By selecting \"I AGREE\", you are thereby agreeing to the End User License Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alertController.addAction(
            UIAlertAction(
                title: "I AGREE",
                style: UIAlertActionStyle.Default, handler: {
                        alertController in self.processSignup()
                    }
            )
        );
        
        alertController.addAction(
            UIAlertAction(
                title: "I do NOT agree",
                style: UIAlertActionStyle.Default,
                handler: nil
            )
        );
        
        // Displays alert
        presentViewController(
            alertController,
            animated: true,
            completion: nil
        );
    }
    
    
    func processSignup() -> Void {
        var userEmail = emailAddress.text!;
        let userPassword = password.text!;
        
        userEmail = userEmail.lowercaseString;
        
        //TODO add email validation
        
        
        
        // Start activity indicator
        //setActivityIndicatorVisibility(true);
        animateIndicator();
        
        // Create new user
        let user = PFUser();
        user.username = userEmail;
        user.password = userPassword;
        user.email = userEmail;
        
        user.signUpInBackgroundWithBlock { (succeed: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier(
                        "toTableView",
                        sender: self
                    );
                }
            } else {
                self.activityIndicator.stopAnimating();
                //self.stopIndicatorAnimations();
                
                if let message: AnyObject = error!.userInfo["error"] {
                    self.message.text = "\(message)";
                }
            }
            
        }
    }
    
    
    
    func showUIAlert(newTitle: String, newMessage: String, newStyle: UIAlertControllerStyle) -> Void {
        if newTitle.isEmpty || newMessage.isEmpty {
            print("> ERROR: Unable to display UI Alert\n> Skipping alert procedure");
            return;
        }
        
        alert = UIAlertController(title: newTitle, message: newMessage, preferredStyle: newStyle);
        
        alert.addAction(DEFAULT_ALERT_ACTION);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        password.resignFirstResponder();
        signIn(textField);
        return true;
    }
    
    /*
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    */
    
    
    func animateIndicator() -> Void {
        if (!activityIndicator.isAnimating()) {
            activityIndicator.startAnimating();
        }
    }
    
    
    func stopIndicatorAnimations() -> Void {
        if (activityIndicator.isAnimating()) {
            activityIndicator.stopAnimating();
        }
    }
    

    
    func hideActivityIndicator() -> Void {
        if (!activityIndicator.hidden) {
            activityIndicator.hidden = true;
        }
    }
    
    func showActivityIndicator() -> Void {
        if (activityIndicator.hidden) {
            activityIndicator.hidden = false;
            activityIndicator.center = self.view.center;
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        }
    }
    
    
    func setActivityIndicatorVisibility(shouldShowIndicator: Bool) -> Void {
        if (shouldShowIndicator) {
            showActivityIndicator();
        } else {
            hideActivityIndicator();
        }
    }
    
    
    func setIndicatorHidesWhenStopped() -> Void {
        if (!activityIndicator.hidesWhenStopped) {
            activityIndicator.hidesWhenStopped = true;
        }
    }
    
    
    func setIndicatorAlwaysVisible() -> Void {
        if (activityIndicator.hidesWhenStopped) {
            activityIndicator.hidesWhenStopped = false;
        }
    }
    
    
    func setActivityIndicatorHidesWhenStopped(indicatorDoesHide: Bool) -> Void {
        if (indicatorDoesHide) {
            setIndicatorAlwaysVisible();
        } else {
            setIndicatorHidesWhenStopped();
        }
    }
    
        
        
        func assignAlertMsg(newAlertMsg: String) -> Void {
            if (newAlertMsg.isEmpty) { return; }
            alertMsg = newAlertMsg;
        }
        
        
        
        func assignMsgTitle(newTitle: String) -> Void {
            if (newTitle.isEmpty) { return; }
            msgTitle = newTitle;
        }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    

}
