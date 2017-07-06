//
//  WodeoProductPage.swift
//  Wodeo 2
//
//  Created by Gareth Long on 28/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit
import StoreKit

class WodeoProductPage: UIViewController {

    
    var delegate:ViewCanceling?
    
    @IBOutlet weak var tableView:UITableView!
    var products = [SKProduct]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action:#selector(WodeoProductPage.reload), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    // priceFormatter is used to show proper, localized currency
    lazy var priceFormatter: NSNumberFormatter = {
        let pf = NSNumberFormatter()
        pf.formatterBehavior = .Behavior10_4
        pf.numberStyle = .CurrencyStyle
        return pf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.refreshControl)
        reload()
        refreshControl.beginRefreshing()
        
        // Subscribe to a notification that fires when a product is purchased.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WodeoProductPage.productPurchased(_:)), name: IAPHelperProductPurchasedNotification, object: nil)

    }
    
    // Fetch the products from iTunes connect, redisplay the table on successful completion
    func reload() {
        products = []
        tableView.reloadData()
        WodeoProducts.store.requestProductsWithCompletionHandler { success, products in
            if success {
                self.products = products
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    // Restore purchases to this device.
    @IBAction func restoreTapped(sender: AnyObject) {
        WodeoProducts.store.restoreCompletedTransactions()
    }
    
    // Purchase the product
    func buyButtonTapped(button: UIButton) {
        let product = products[button.tag]
        WodeoProducts.store.purchaseProduct(product)
    }
    
    // When a product is purchased, this notification fires, redraw the correct row
    func productPurchased(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        UserSettings.sharedInstance.savePurchasedVideo()
        for (index, product) in products.enumerate() {
            
            
            
            if product.productIdentifier == productIdentifier {
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
                break
            }
        }
    }

    
    //Admin
    override func prefersStatusBarHidden() -> Bool {
        return true 
    }
    
    @IBAction func didCancel(sender:UIButton){
        if let d = delegate{
            d.viewDidCancel()
        }
    }
   
}

extension WodeoProductPage:UITableViewDelegate {
    
}


extension WodeoProductPage:UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        let product = products[indexPath.row]
        cell.textLabel?.text = product.localizedTitle
        
        if WodeoProducts.store.isProductPurchased(product.productIdentifier) {
            cell.accessoryType = .Checkmark
            cell.accessoryView = nil
            cell.detailTextLabel?.text = ""
        }
        else if IAPHelper.canMakePayments() {
            priceFormatter.locale = product.priceLocale
            //cell.detailTextLabel?.text = priceFormatter.stringFromNumber(product.price)
            
            let button = BorderButton(frame: CGRect(x: 0, y: 0, width: 100.0, height: 37))
            button.setTitleColor(view.tintColor, forState: .Normal)
            button.setTitle("\(priceFormatter.stringFromNumber(product.price)!)", forState: .Normal)
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(WodeoProductPage.buyButtonTapped(_:)), forControlEvents: .TouchUpInside)
            cell.accessoryType = .None
            cell.accessoryView = button
        } else {
            cell.accessoryType = .None
            cell.accessoryView = nil
            cell.detailTextLabel?.text = "Not Available"
        }
        return cell    }

}
