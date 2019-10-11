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
    
    @IBOutlet weak var viewMoreLbl: UILabel!
    @IBOutlet weak var scrollDownArrow: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // set the bold text for title texts
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
        

        SDSCoreScrolView.delegate = self

        // check the current rotation

        self.viewMoreLbl.isHidden = true
        self.scrollDownArrow.isHidden = true
        self.SDSCoreScrolView.isHidden = true
        
        
        self.callSDSCore()
    }
    

    // call the WCF
    func callSDSCore() {
        csiWCF_VM().callSDS_Core() { (output) in
            if output.contains("true") {
//                print("Successfully called Core info.!")
                self.getValue()
            } else {
                print("Something missing!")
            }
        }
    }
    
    //give the labels value and set the views
    func getValue() {
        DispatchQueue.main.async {
            self.prodname.text = localViewSDSCore.prodname
            self.company.text = localViewSDSCore.company
            self.prodcode.text = localViewSDSCore.prodcode
            self.emcont.text = localViewSDSCore.emcont
            self.recomuse.text = localViewSDSCore.recomuse
            self.sds.text = localViewSDSCore.sds
            self.issuedate.text = localViewSDSCore.issuedate
            self.expirydate.text = localViewSDSCore.expirydate
            self.ps.text = localViewSDSCore.ps
            self.hs.text = localViewSDSCore.hs
            self.dg.text = localViewSDSCore.dg
            self.unno.text = localViewSDSCore.unno

            self.viewMore()
            self.SDSCoreScrolView.isHidden = false

        }
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = SDSCoreScrolView.contentOffset.y + SDSCoreScrolView.frame.size.height
        SDSCoreScrolView.sizeToFit()
        DispatchQueue.main.async {
            if (bottomEdge >= self.SDSCoreScrolView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            } else if (bottomEdge < self.SDSCoreScrolView.contentSize.height - 10)
            {
                self.viewMore()
            }
        }
    }
    
    //detect the rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.viewMore()
        }

    }
    
    //setup the notification for the content over the screen
    func viewMore() {
        
        //set real size for each label
        ProdNT.sizeToFit()
        prodname.sizeToFit()
        ComNT.sizeToFit()
        company.sizeToFit()
        ProdCT.sizeToFit()
        prodcode.sizeToFit()
        infoT.sizeToFit()
        issuT.sizeToFit()
        expiT.sizeToFit()
        DangT.sizeToFit()
        hazaT.sizeToFit()
        psT.sizeToFit()
        unnoT.sizeToFit()
        EmerT.sizeToFit()
        emcont.sizeToFit()
        recoT.sizeToFit()
        recomuse.sizeToFit()
        
        contentView.sizeToFit()
        SDSCoreScrolView.sizeToFit()
        //cal the total height of the content
        let cont1 = self.ProdNT.frame.height + self.prodname.frame.height
        let cont2 = self.ComNT.frame.height + self.company.frame.height
        let cont3 = self.ProdCT.frame.height + self.prodcode.frame.height
        let cont4 = self.infoT.frame.height + self.issuT.frame.height
        let cont5 = self.expiT.frame.height + self.DangT.frame.height
        let cont6 = self.hazaT.frame.height + self.psT.frame.height
        let cont7 = self.unnoT.frame.height + self.EmerT.frame.height
        let cont8 = self.emcont.frame.height + self.recoT.frame.height + self.recomuse.frame.height
                
        let conT = cont1 + cont2 + cont3 + cont4 + cont5 + cont6 + cont7 + cont8
        
//        print("content view: \(contentView.frame.height)")
//        print("Scroll view: \(SDSCoreScrolView.frame.height)")
//        print("total: \(conT)\n")
        
        //check if the real content height is over or less the content view height
        if (contentView.frame.height > SDSCoreScrolView.frame.height) {

            self.viewMoreLbl.isHidden = false
            self.scrollDownArrow.isHidden = false
        } else if (contentView.frame.height < SDSCoreScrolView.frame.height) {
            if (SDSCoreScrolView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }
            
        }

    }


}
