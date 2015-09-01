//
//  InterfaceController.swift
//  The Spy fm WatchKit Extension
//
//  Created by Justin Oakes on 6/26/15.
//  Copyright (c) 2015 Justin Oakes. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var infoLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.infoLabel.setText(TrackInfoController.sharedInstance.getSongInfo())
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pausePlay() {
       
        
        WKInterfaceController.openParentApplication(["pause/play" : true], reply: { (reply, error) -> Void in

        })
    }
}
