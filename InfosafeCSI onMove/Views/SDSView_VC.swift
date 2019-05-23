//
//  SDSView_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 5/13/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit
import WebKit

class SDSView_VC: UIViewController {

    @IBOutlet weak var sdsDisplay: WKWebView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.sdsShowPDF()
        self.sdsShow()
    }
    
    func sdsShow() {
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSDS() { (completionReturnData) in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.sdsDisplay!.loadHTMLString(completionReturnData, baseURL: nil)
            }
            
        }
    }
}



