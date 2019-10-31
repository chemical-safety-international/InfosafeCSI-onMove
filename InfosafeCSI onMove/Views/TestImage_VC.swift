//
//  TestImage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 31/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class TestImage_VC: UIViewController {
    
    @IBOutlet weak var bcImg: UIImageView!
    
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bcBtnTapped(_ sender: Any) {
        print(count)
        if count == 0 {
            bcImg.image = UIImage(named: "road1")
            count += 1
        } else if count == 1 {
            bcImg.image = UIImage(named: "road2")
            count += 1
        } else if count == 2 {
            bcImg.image = UIImage(named: "road3")
            count += 1
        } else if count == 3 {
            bcImg.image = UIImage(named: "road4")
            count += 1
            
        }  else if count == 4 {
             bcImg.image = UIImage(named: "sea1")
             count += 1
         } else if count == 5 {
             bcImg.image = UIImage(named: "sea2")
             count += 1
         } else if count == 6 {
             bcImg.image = UIImage(named: "sea3")
             count += 1
         } else if count == 7 {
             bcImg.image = UIImage(named: "sea4")
             count += 1
         } else if count == 8 {
             bcImg.image = UIImage(named: "sea5")
             count += 1
         }  else if count == 9 {
             bcImg.image = UIImage(named: "air1")
             count += 1
         } else if count == 10 {
             bcImg.image = UIImage(named: "air2")
             count = 0
         }
        
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

