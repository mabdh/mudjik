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

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var spotifyButton1: UIButton!

    @IBOutlet weak var spotifyButton2: UIButton!
    
    @IBAction func openSpotifyButton(_ sender: AnyObject) {
        
        
        self.openSpotify(user_id: self.uid, playlist_id: self.pid)
        moodLabel.isHidden = true;
        spotifyButton2.isHidden = true;
        spotifyButton1.isHidden = true;
    }
    var uid: String = ""
    var pid: String = ""
    var mood:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.hidesWhenStopped = true;
        if !activityIndicator.isAnimating {
            activityIndicator.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCameraButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapUploadButton(_ sender: AnyObject)
    {
        
        if let im = imagePicked.image {
            uploadImage(
                image: imagePicked.image!,
                progress: { [unowned self] percent in
                    // 2
                },
                completion: { (s) in
                    // 3
                    print()
                    self.activityIndicator.stopAnimating()
                    
                })
        }else{
            let alertController = UIAlertController(title: "No photo", message: "There is no photo taken or selected", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        imagePicked.image = image
        self.dismiss(animated: true, completion: nil);
    }
    


}

// Networking calls
extension ViewController {
    func uploadImage(image: UIImage, progress: (_ percent: Float) -> Void, completion: @escaping (_ s:String)->Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        
        DispatchQueue.main.async() {
            self.activityIndicator.startAnimating()
        }
        
        var imgur:ImgurAnonymousAPIClient = ImgurAnonymousAPIClient()
        imgur.clientID = "d4c1ea2055f92f5"
        imgur.uploadImage(image,withFilename:randomStringWithLength(len: 10) + ".jpeg", completionHandler:{(url,err) in
            debugPrint(url)
            debugPrint(err)
            if !(err != nil) {
                print("\(url)")
                self.sendToServer(url: (url?.absoluteString)!)
            }
        })

        

        
    }
    
    
    func sendToServer(url: String){
        let parameters: Parameters = ["url":  url,"context": "mood"]

        Alamofire.request("http://10.42.0.1:8080/local-generate", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("To server")
                debugPrint(response)
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    let dictVar = response.result.value
                    // user id && play list
                    print(swiftyJsonVar.string)
                    //self.uid = swiftyJsonVar["user_id"].stringValue
                    //self.pid = swiftyJsonVar["playlist_id"].stringValue
                    //self.mood = swiftyJsonVar["mood"].stringValue
                    
                    self.uid =  swiftyJsonVar["user_id"].stringValue
                    self.pid = swiftyJsonVar["playlist_id"].stringValue
                    self.mood = swiftyJsonVar["mo_od"].string!
                    
                    self.moodLabel.text = self.mood;
                    self.moodLabel.isHidden = false;
                    self.spotifyButton2.isHidden = false;
                    self.spotifyButton1.isHidden = false;
                    
                
                }
        }
    
    }
    

    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for _ in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
    
    func openSpotify(user_id:String, playlist_id:String){
        print(user_id)
        print(playlist_id)
        var spotifyHooks = "spotify://https://open.spotify.com/user/"+user_id+"/playlist/"+playlist_id
        var spotifyURLWeb = "https://play.spotify.com/user/"+user_id+"/playlist/"+playlist_id
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

