//
//  BallicticStashView.swift
//  Wodeo 2
//
//  Created by Gareth Long on 15/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

protocol BallicticStashDelegate {
    func ballisticStachDidReturn()
}

class BallicticStashView: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var delegate:BallicticStashDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string:"http://www.ballisticstash.co.uk/?v=79cba1185463")
        
        let request = NSURLRequest(URL:url!)
        
        webView.loadRequest(request)
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed(sender: AnyObject) {
        delegate!.ballisticStachDidReturn()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        UIView.animateWithDuration(0.6, animations: {
            webView.alpha = 1.0
        })
        
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
