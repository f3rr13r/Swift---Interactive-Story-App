//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Harry Ferrier on 6/22/16.
//  Copyright © 2016 CASTOVISION LIMITED. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    enum Error: ErrorType {
        case NoName
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Error.NoName
                    }
                    
                    if let pageController = segue.destinationViewController as? PageController {
                        pageController.page = Adventure.story(name)
                    }
                }
            } catch Error.NoName {
               let alertController = UIAlertController(title: "Name Not Provided", message: "Please provided a name to start your adventure", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                
                presentViewController(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error)")
            }
        }
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDictionary = notification.userInfo, keyboardFrameValue = userInfoDictionary[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height - 30.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.8) {
           self.textFieldBottomConstraint.constant = 40.0
           self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - UITextFieldDelegate 
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



















