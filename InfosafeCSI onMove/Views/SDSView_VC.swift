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
        let rtype : String = "1"
        csiWCF_VM().callSDS(rtype : rtype) { (completionReturnData) in
            DispatchQueue.main.async {
                self.removeSpinner()
                
                if rtype == "1" {
                    print(completionReturnData)
                    if let decodeData = Data(base64Encoded: completionReturnData, options: .ignoreUnknownCharacters) {
                        self.sdsDisplay!.load(decodeData, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: URL(fileURLWithPath: ""))
                    } // since you don't have url, only encoded String
                }
                else if rtype == "2" {
                    self.sdsDisplay!.loadHTMLString(String(describing: completionReturnData), baseURL: nil)
                }
            }
            
        }
    }
}



