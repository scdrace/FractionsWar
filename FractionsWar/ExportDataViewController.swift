//
//  ExportDataViewController.swift
//  FractionsWar
//
//  Created by David Race on 8/15/16.
//
//

import UIKit
import UIKit
import MessageUI

class ExportDataViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var messageVC: MFMailComposeViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("MailPresenter")
        //self.view.backgroundColor = UIColor(red: 0, green: 153, blue: 0, alpha: 1)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Do any additional setup after loading the view.
        mailCheck()
        presentMail()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'_'MM'_'dd'_'a'_'HH'_'mm'_'ss"
        
        let date = Date()
        print(String(describing: date))
        
        let dateX = dateFormatter.string(from: date)
        print(dateX)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func export() {
        presentMail()
    }
    
    /*
    func loadData() {
        do {
            let myEssay = try String(contentsOfURL: itemArchiveURL, encoding: NSUTF8StringEncoding)
            print(myEssay)
        }
        catch {
            print("Error reading from URL: \(error)")
        }
    }
    */
    
    func mailCheck() -> Bool {

        if !MFMailComposeViewController.canSendMail() {
            print("mail services are not available")
            return false
        }
        
        return true
    }
    
    func presentMail() {
        
        print("PresentMail")
        
        messageVC = MFMailComposeViewController()
        messageVC.mailComposeDelegate = self
        
        messageVC.setToRecipients(["address@example.com"])
        messageVC.setSubject("FractionsWarData")
        messageVC.setMessageBody("Please update email address and press \("Send") to send data", isHTML: false)
        
        attachFiles()
        
        //text/tab-separated-values
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true) {
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }

    
    func attachFiles() {
        
        if let files = getDatafileNames() {            
            for file in files {
                let data = FileManager.default.contents(atPath: file.path)
                
                messageVC.addAttachmentData(data!, mimeType: "text/plain", fileName: file.lastPathComponent)
            }
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
