//
//  AlbumArtFinder.swift
//  The Spy fm
//
//  Created by Justin Oakes on 9/10/15.
//  Copyright © 2015 Justin Oakes. All rights reserved.
//

import UIKit

class AlbumArtFinder: NSObject {
    
    var image: UIImage = UIImage(named: "vinyl1x")!
    
    func getAlbumArtFor(song: NSString, artist: NSString)  {
        let baseURLString: String = "https://itunes.apple.com/search?term="
        var fullURLString = "\(baseURLString)\(artist) \(song)"
        fullURLString = fullURLString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
        fullURLString = fullURLString.stringByReplacingOccurrencesOfString("++", withString: "+", options: [], range: nil)
        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: fullURLString)!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, responce, error) -> Void in
            var songs: NSDictionary? = nil
            do {
                songs = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
            }catch{
                print(error)
            }
            if songs != nil {
                let songArray: NSArray = songs?.objectForKey("results") as! NSArray
                if songArray.count > 0 {
                    let songDictionary: NSDictionary = songArray[0] as! NSDictionary
                    var songURL: String = songDictionary["artworkUrl100"] as! String
                    songURL = songURL.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
                    
                    let songImageData: NSData = NSData(contentsOfURL: NSURL(string: songURL)!)!
                    let songImage: UIImage = UIImage(data: songImageData)!

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image = songImage
                        NSNotificationCenter.defaultCenter().postNotificationName("imageChange", object: nil)
                    })
                } else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image = UIImage(named: "vinyl1x")!
                        NSNotificationCenter.defaultCenter().postNotificationName("imageChange", object: nil)
                    })
                }
            }
        })
        task.resume()
    }

}
