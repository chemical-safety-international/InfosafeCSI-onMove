//
//  Startup_VC.swift
//  InfosafeCSI onMove
//
//  Created by Feng Liu on 16/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class StartupPage_VC: UIViewController {
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var bgImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        textLbl.font = UIFont.italicSystemFont(ofSize: 25)
        textLbl.font = UIFont.boldSystemFont(ofSize: 25)
        
//        let image = UIImage(named: "button")
//        startBtn.setImage(image, for: .normal)
//        setNavigationBar()
        deviceName()
        modelName()
        UUID()
//        currentDevice()
//        checkVersionUpdate()
        
        
        if (appUpdateAvailable() != false) {
            startBtn.isHidden = false
        } else {
            startBtn.isHidden = true
            goToAppStore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.enableAllOrientation = true
//            let image = UIImage(named: "CSI-SC")
//            let newImage = image!.rotate(radians: .pi/2)
//            bgImg.image = newImage
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
        
    
    func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.75, blue:0.75, alpha:1.0)
        navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.hidesBackButton = true
        
        
        let image1 = UIImage(named: "CSI-Logo1")
        let imageView = UIImageView(frame: CGRect(x: 0, y: -5, width: 80, height: 30))
        //imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleToFill
        
        imageView.image = image1
        navigationItem.titleView?.backgroundColor = UIColor.clear
        navigationItem.titleView = imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func modelName() {
        let modelName = UIDevice.modelName
        locallogininfo.model = modelName
//        print("Model name: \(modelName)\n")
        
    }
    
    // for identify the device uniquely (will create a new one after reinstalling)
    func UUID() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        locallogininfo.UUID = uuid
//        print("UUID: \(uuid ?? "")\n")
    }
    
    func deviceName() {
        let deviceName = UIDevice.current.name
        locallogininfo.deviceName = deviceName
//        print("Device name: \(deviceName)\n")
        
    }
    
//    func currentDevice() {
//
//        print("Device systen name: \(UIDevice.current.systemName)\n")
//        print("Device system version: \(UIDevice.current.systemVersion)\n")
//    }
    
    func checkVersionUpdate() {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        print(version)
    }
    
      func appUpdateAvailable() -> Bool
    {
//        let storeInfoURL: String = "https://apps.apple.com/nz/app/chemical-safety-infosafecsi/id1462709058"
        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=com.chemicalsafety.InfosafeCSI-onMove"
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            let urlOnAppStore = NSURL(string: storeInfoURL)
            if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
                // Try to deserialize the JSON that we got
                if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                    if let results:NSArray = dict["results"] as? NSArray {
//                        print(results)
                        if let version = (results[0] as AnyObject).value(forKey: "version") as? String {
                            // Get the version number of the current version installed on device
                            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                // Check if they are the same. If not, an upgrade is available.
//                                print("\(version)")
//                                print(currentVersion)
                                if (version != currentVersion) && (version > currentVersion) {
                                    upgradeAvailable = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return upgradeAvailable
    }
    
    func goToAppStore() {
        let appStoreAppID = "1462709058"
        UIApplication.shared.open(URL(string: "itms://itunes.apple.com/app/id" + appStoreAppID)!)
    }
    
}


