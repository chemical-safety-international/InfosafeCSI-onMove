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

}


