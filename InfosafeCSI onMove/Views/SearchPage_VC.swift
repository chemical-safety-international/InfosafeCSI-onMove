//
//  SearchPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchPage_VC: UIViewController {

    var loginDataSet:(String,String,String) = ("","","")
    //IBOutlet
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func  getLoginData(loginData: (String,String,String)) {
//        loginDataSet = loginData
//        print("LoginDataSet: \(loginDataSet)")
//    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        
        let searchInPut = searchTextField.text!
        csiclientsearchinfo.arrName = []
        csiclientsearchinfo.arrDetail = []
        csiclientsearchinfo.arrNo = []
        //call search function
        print("loginDataSetis \(String(describing: csiclientinfo.clientid))")
        csiWCF_VM().callSearch(clientid: csiclientinfo.clientid, infosafeid: csiclientinfo.infosafeid, inputData: searchInPut)

        
//        let loginJump = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//        self.navigationController?.pushViewController(loginJump!, animated: true)
        
    }
}
