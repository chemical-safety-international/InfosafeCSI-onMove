//
//  SDSViewCore_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 3/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewCore_VC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var CoreTitle: UILabel!
    
    @IBOutlet weak var ProdNT: UILabel!
    @IBOutlet weak var ComNT: UILabel!
    @IBOutlet weak var ProdCT: UILabel!
    @IBOutlet weak var infoT: UILabel!
    @IBOutlet weak var issuT: UILabel!
    @IBOutlet weak var expiT: UILabel!
    @IBOutlet weak var DangT: UILabel!
    @IBOutlet weak var hazaT: UILabel!
    @IBOutlet weak var psT: UILabel!
    @IBOutlet weak var unnoT: UILabel!
    @IBOutlet weak var EmerT: UILabel!
    @IBOutlet weak var recoT: UILabel!
    

    @IBOutlet weak var prodname: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var prodcode: UILabel!
    @IBOutlet weak var sds: UILabel!
    @IBOutlet weak var issuedate: UILabel!
    @IBOutlet weak var expirydate: UILabel!
    @IBOutlet weak var ps: UILabel!
    @IBOutlet weak var hs: UILabel!
    @IBOutlet weak var dg: UILabel!
    @IBOutlet weak var unno: UILabel!
    @IBOutlet weak var emcont: UILabel!
    @IBOutlet weak var recomuse: UILabel!
    
    @IBOutlet var SDSCoreView: UIView!
    @IBOutlet weak var SDSCoreScrolView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        SDSCoreView.backgroundColor = UIColor(red:0.37, green:0.52, blue:0.07, alpha:1.0)
        
        CoreTitle.font = UIFont.boldSystemFont(ofSize: 25)
        ProdNT.font = UIFont.boldSystemFont(ofSize: 16)
        ComNT.font = UIFont.boldSystemFont(ofSize: 16)
        ProdCT.font = UIFont.boldSystemFont(ofSize: 16)
        infoT.font = UIFont.boldSystemFont(ofSize: 16)
        issuT.font = UIFont.boldSystemFont(ofSize: 16)
        expiT.font = UIFont.boldSystemFont(ofSize: 16)
        DangT.font = UIFont.boldSystemFont(ofSize: 16)
        hazaT.font = UIFont.boldSystemFont(ofSize: 16)
        psT.font = UIFont.boldSystemFont(ofSize: 16)
        unnoT.font = UIFont.boldSystemFont(ofSize: 16)
        EmerT.font = UIFont.boldSystemFont(ofSize: 16)
        recoT.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        
//        SDSCoreScrolView.addSubview(contentView)
//        SDSCoreScrolView.contentSize = contentView.frame.size
        
//        SDSCoreScrolView.delegate = self
//        SDSCoreScrolView.isScrollEnabled = true
//        SDSCoreScrolView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        SDSCoreScrolView.delegate = self
        self.SDSCoreScrolView.addSubview(contentView)

            SDSCoreScrolView.contentSize = CGSize(width: self.SDSCoreScrolView.frame.size.width, height: 700)
        self.callSDSCore()
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        SDSCoreScrolView.contentSize = CGSize(width: self.SDSCoreScrolView.frame.size.width, height: 100)
////        self.SDSCoreScrolView.frame.size.height
//    }
    
    override func viewDidLayoutSubviews() {
//                SDSCoreScrolView.delegate = self
        
//        SDSCoreScrolView.contentSize = CGSize(width: self.SDSCoreScrolView.frame.size.width, height: 700)
        
//                SDSCoreScrolView.addSubview(contentView)
//                SDSCoreScrolView.contentSize = contentView.frame.size
    }
    
    
    
    func callSDSCore() {
        csiWCF_VM().callSDS_Core() { (output) in
            if output.contains("true") {
                print("Successfully called Core info.!")
                self.getValue()
            } else {
                print("Something missing!")
            }
        }
    }
    
    func getValue() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        DispatchQueue.main.async {
            self.prodname.text = localViewSDSCore.prodname
            self.company.text = localViewSDSCore.company
            self.prodcode.text = localViewSDSCore.prodcode
            self.emcont.text = localViewSDSCore.emcont
            self.recomuse.text = localViewSDSCore.recomuse
            self.sds.text = localViewSDSCore.sds
            self.issuedate.text = localViewSDSCore.issuedate
//            self.issuedate.text = formatter.string(from: localViewSDSCore.issuedate)
//            self.issuedate.text = String(data: localViewSDSCore.issuedate, encoding: .utf8)
            self.expirydate.text = localViewSDSCore.expirydate
            self.ps.text = localViewSDSCore.ps
            self.hs.text = localViewSDSCore.hs
            self.dg.text = localViewSDSCore.dg
            self.unno.text = localViewSDSCore.unno
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
