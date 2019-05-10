//
//  SearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchPage_VC: UIViewController {

    //IBOutlet
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func searchBtnTapped(_ sender: Any) {
        
        let searchInPut = searchTextField.text!
        
        //call search function
        //csiWCF_VM().callSearch(loginData: csiWCF_VM().loginData, inputData: searchInPut)
        
//        let loginJump = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//        self.navigationController?.pushViewController(loginJump!, animated: true)
        
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
