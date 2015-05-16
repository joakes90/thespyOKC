//
//  NowPlayingViewController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 12/6/14.
//  Copyright (c) 2014 Justin Oakes. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingViewController: UIViewController {
    
    let songURL = NSURL(string: "http://www.thespyfm.com/media/template.html")
    var showAlert: Bool = true
    
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
            pageContent = pageContent?.stringByReplacingOccurrencesOfString(i as String, withString: "\n")
        }
        pageContent = pageContent?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let infoArray = pageContent?.componentsSeparatedByString("\n")
        if infoArray == nil {
            if showAlert == true{
                let alert: UIAlertView = UIAlertView(title: "No Network Connection", message: "The Spy FM is currently not available. Please try again later", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                showAlert = false
            }
        }else {
        
        let currentArtist: String = String(infoArray![0] as! NSString)
        
        let currentTrack: String = String(infoArray![19] as! NSString)
        
        let mediaPlayer: MPNowPlayingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
        
        if (currentTrack != "") {
            var songInfo: NSMutableDictionary = [MPMediaItemPropertyTitle : currentTrack, MPMediaItemPropertyArtist : currentArtist, MPMediaItemPropertyAlbumTitle : "The Spy"]
            mediaPlayer.nowPlayingInfo = songInfo as [NSObject : AnyObject]
        }
        artist.text = "By \(currentArtist)"
        track.text = "Now Playing: \(currentTrack)"
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
