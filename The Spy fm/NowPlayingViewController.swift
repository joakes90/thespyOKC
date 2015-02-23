//
//  NowPlayingViewController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 12/6/14.
//  Copyright (c) 2014 Justin Oakes. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    let songURL = NSURL(string: "http://www.thespyfm.com/media/template.html")
    
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var track: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSongInfo()
        let timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "getSongInfo", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getSongInfo(){
        let elementsToStrip: [NSString] = ["<div class=\"now-playing\">",
            "<h3>Now<br>Playing</h3>",
            "<div class=\"info\">",
            "<div class=\"artist\">",
            "<span>Artist: </span>",
            "</div>", "<div class=\"title\">",
            "<span>Title: </span>",
            "<div class=\"just-missed\">",
            "<h3>Just<br>Missed</h3>",
            "\n", "\r", "\t"]
        
        var pageContent = NSString(contentsOfURL: songURL!, encoding: NSUTF8StringEncoding, error: nil)
        
        
        for i in elementsToStrip{
            pageContent = pageContent?.stringByReplacingOccurrencesOfString(i, withString: "\n")
        }
        pageContent = pageContent?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let infoArray = pageContent?.componentsSeparatedByString("\n")
        
        let currentArtist: String = String(infoArray![0] as NSString)
        
        let currentTrack: String = String(infoArray![19] as NSString)
        
        
        artist.text = currentArtist
        track.text = currentTrack
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
