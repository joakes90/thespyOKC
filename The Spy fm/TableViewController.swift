//
//  TableViewController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 6/18/15.
//  Copyright (c) 2015 Justin Oakes. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTableView", name: "newTweets", object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        TwitterController.sharedInstance.getNewTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func refreshTableView() {
        self.tabelView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if TwitterController.sharedInstance.tweets != nil {
            return TwitterController.sharedInstance.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tabelView.dequeueReusableCellWithIdentifier("cell")! as! TwitterCellTableViewCell
        
        cell.label.text = (TwitterController.sharedInstance.tweets![indexPath.row]["text"]! as! String)
        
        return cell
    }

    
    
}
