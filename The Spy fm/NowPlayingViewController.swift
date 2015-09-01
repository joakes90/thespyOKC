//
//  NowPlayingViewController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 12/6/14.
//  Copyright (c) 2014 Justin Oakes. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class NowPlayingViewController: UIViewController {
    
    
    let songURL = NSURL(string: "http://www.thespyfm.com/media/template.html")
    var showAlert: Bool = true
    
    @IBOutlet var pausePlayButton: UIButton!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var track: UILabel!
    let Commandcenter: MPRemoteCommandCenter = MPRemoteCommandCenter.sharedCommandCenter()
    
    var audioPlayer: AVPlayer?
    
    var playing: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Commandcenter.playCommand.addTarget(self, action: "toggle:")
        Commandcenter.pauseCommand.addTarget(self, action: "toggle:")
        
        
        audioPlayer =  AVPlayer(URL: NSURL(string: "http://50.7.70.58:8691/live")!)
        audioPlayer?.play()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggle:", name: "pauseplay", object: nil)
        
        
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }

        self.getSongInfo()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "getSongInfo", userInfo: nil, repeats: true)
        
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        
        var pageContent: NSString?

        do {
            pageContent =  try NSString(contentsOfURL: songURL!, encoding: NSUTF8StringEncoding)
        } catch _ {
            pageContent = nil
        }
        
        
        for i in elementsToStrip{
            pageContent = pageContent?.stringByReplacingOccurrencesOfString(i as String, withString: "\n")
        }
        pageContent = pageContent?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let infoArray = pageContent?.componentsSeparatedByString("\n")
        if infoArray == nil {
            if showAlert == true{
                let alert: UIAlertController = UIAlertController(title: "No Network Connection", message: "The Spy FM is currently not available. Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                let action: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                })
                
                alert.addAction(action)
                
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                    
                })
                
                showAlert = false
            }
        }else {
            
            let currentArtist: String = String(infoArray![0] as NSString)
            
            let currentTrack: String = String(infoArray![19] as NSString)
            
            let album: NSString = "The Spy" as NSString
            
            let mediaPlayer: MPNowPlayingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
            
            
            if (currentTrack != "") {
                let rate: Double = playing == true ? 1.0 : 0.0
                let songInfo = [MPMediaItemPropertyTitle : currentTrack, MPMediaItemPropertyArtist : currentArtist, MPMediaItemPropertyAlbumTitle : album, MPNowPlayingInfoPropertyPlaybackRate : rate]
                mediaPlayer.nowPlayingInfo = songInfo as [String : AnyObject]
            }
            artist.text = "By: \(currentArtist)"
            track.text = "Now Playing: \(currentTrack)"
        }
        
    }
    
    
    @IBAction func toggle(sender: AnyObject) {
        if playing {
            audioPlayer?.pause()
            self.pausePlayButton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            playing = false
            self.getSongInfo()
        } else{
            audioPlayer = AVPlayer(URL: NSURL(string: "http://50.7.70.58:8691/live")!)
            audioPlayer?.play()
            playing = true
            self.pausePlayButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            self.getSongInfo()
        }
    }
}