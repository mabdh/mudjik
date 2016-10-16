//
//  ViewController.swift
//  Mudjik
//
//  Created by Muhammad Abduh on 10/15/16.
//  Copyright © 2016 Muhammad Abduh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ImgurAnonymousAPIClient

class mdViewController: UIViewController {
    
    @IBOutlet weak var moodLabel: UILabel!
    
    var datauid:String?
    var datapid:String?
    var datamood:String?
    
    @IBAction func openSpotify(_ sender: AnyObject) {
        
        openSpotify(user_id: datauid!, playlist_id: datapid!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moodLabel?.text = datamood ?? nil
        print(datamood)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

// Networking calls
extension mdViewController {

    
    func openSpotify(user_id:String, playlist_id:String){
        var spotifyHooks = "spotify://https://open.spotify.com/user/\(user_id)/playlist/\(playlist_id)"
        var spotifyURLWeb = "https://play.spotify.com/user/\(user_id)/playlist/\(playlist_id)"
        
        print(spotifyHooks)
        print(spotifyURLWeb)
        var spotifyURL = NSURL(string: spotifyHooks)
        if UIApplication.shared.canOpenURL(spotifyURL! as URL)
        {
            UIApplication.shared.openURL(spotifyURL! as URL)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: spotifyURLWeb)! as URL)
        }
    }
}

