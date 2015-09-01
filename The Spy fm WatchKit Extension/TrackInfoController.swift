//
//  TrackInfoController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 6/26/15.
//  Copyright (c) 2015 Justin Oakes. All rights reserved.
//

import UIKit

class TrackInfoController: NSObject {
    
    static let sharedInstance: TrackInfoController = TrackInfoController()
    
    let songURL = NSURL(string: "http://www.thespyfm.com/media/template.html")
    
    func getSongInfo() -> String{
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
            pageContent = try NSString(contentsOfURL: songURL!, encoding: NSUTF8StringEncoding)
        } catch _ {
            pageContent = nil
        }
        
        
        for i in elementsToStrip{
            pageContent = pageContent?.stringByReplacingOccurrencesOfString(i as String, withString: "\n")
        }
        pageContent = pageContent?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let infoArray = pageContent?.componentsSeparatedByString("\n")
        
        
        let currentArtist: String = String(infoArray![0] as NSString)
        
        let currentTrack: String = String(infoArray![19] as NSString)
        
        return "\(currentTrack) By: \(currentArtist)"
        
    }
    
}

