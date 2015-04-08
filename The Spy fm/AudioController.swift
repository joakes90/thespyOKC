//
//  AudioController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 12/2/14.
//  Copyright (c) 2014 Justin Oakes. All rights reserved.
//

import UIKit
import AVFoundation

class AudioController: UIViewController {

    @IBOutlet weak var player: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentUrl: NSURL = NSURL(string: "http://oklasoftware.com/thespy/audiotest.html")!
        let urlRequest: NSURLRequest = NSURLRequest(URL: contentUrl)
        player.allowsInlineMediaPlayback = true
        player.mediaPlaybackRequiresUserAction = false
        player.scrollView.scrollEnabled = false
        player.scrollView.bounces = false
        player.loadRequest(urlRequest)
        
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(true, error: nil)
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

}
