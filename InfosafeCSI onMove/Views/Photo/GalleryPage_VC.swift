//
//  GalleryPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 16/7/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class GalleryPage_VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getImage(imageName: "test.png")
    }
    
    func getImage(imageName: String) {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        print(imagePath)
        
        self.imageView.image = UIImage(contentsOfFile: imagePath)
//        if fileManager.fileExists(atPath: imagePath) {
//            imageView.image = UIImage(contentsOfFile: imagePath)
//        } else {
//            print("No picture find.")
//        }
    }

    @IBAction func callReload(_ sender: Any) {
        self.view.reloadInputViews()
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
