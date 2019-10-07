//
//  AboutViewController.swift
//  iCalculate
//
//  Created by Kevin Kim on 7/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func websiteLink(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string:"https://kevink1103.github.io/")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func sendEmail(_ sender: UIBarButtonItem) {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Mail Unabled", message: "Please register Mail.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
         
        // Configure the fields of the interface.
        composeVC.setToRecipients(["kevink1103@gmail.com"])
        composeVC.setSubject("iCalculate Feedback")
        composeVC.setMessageBody("Dear Kevin,", isHTML: false)
         
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
