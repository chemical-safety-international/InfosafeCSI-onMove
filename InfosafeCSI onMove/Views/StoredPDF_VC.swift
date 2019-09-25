//
//  StoredPDF_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 26/8/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class StoredPDF_VC: UIViewController {

    @IBOutlet weak var textDisplay: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callPDFFetch()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func callPDFFetch() {
        let pdfArray = CoreDataManager.fetchPDF()
        var text = "Total: \(pdfArray.count)\n"
        for index in 0..<pdfArray.count {
            text += "SDS No.: \(pdfArray[index].sdsno!)\n"
        }
//        text += "Total: \(pdfArray.count)"
        textDisplay.text = text
    }
    
    @IBAction func cleanBtn(_ sender: Any) {
        DispatchQueue.main.async {
//            CoreDataManager.cleanTempData()
            CoreDataManager.cleanPDFCoreData()
            self.callPDFFetch()
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
