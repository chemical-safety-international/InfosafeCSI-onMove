//
//  MultipleLoginPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 13/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class OTACODEPage_VC: UIViewController {

    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.passwordTextView.isHidden = true
        self.loginButton.backgroundColor = UIColor.gray
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
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
