//
//  SDSViewCF_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewCF_VC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var CLST: UILabel!
    
    @IBOutlet weak var HAZT: UILabel!
    @IBOutlet weak var RIST: UILabel!
    @IBOutlet weak var SAFT: UILabel!
    
    @IBOutlet weak var haz: UILabel!
    @IBOutlet weak var risk: UILabel!
    @IBOutlet weak var safety: UILabel!
    
    @IBOutlet weak var CFScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var viewMoreLbl: UILabel!
    @IBOutlet weak var scrollDownArrow: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        CLST.font = UIFont.boldSystemFont(ofSize: 25)
        HAZT.font = UIFont.boldSystemFont(ofSize: 16)
        RIST.font = UIFont.boldSystemFont(ofSize: 16)
        SAFT.font = UIFont.boldSystemFont(ofSize: 16)
        
        CFScrollView.delegate = self
        
        CFScrollView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        callCF()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func callCF() {
        getValue()
        self.removeSpinner()
    }
    
    func getValue() {
        DispatchQueue.main.async {
            self.haz.text = localViewSDSCF.classification
            self.risk.text = localViewSDSCF.rphrase
            self.safety.text = localViewSDSCF.sphrase
            
            self.viewMore()
            self.CFScrollView.isHidden = false
        }
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = CFScrollView.contentOffset.y + CFScrollView.frame.size.height
        CFScrollView.sizeToFit()
        DispatchQueue.main.async {
            if (bottomEdge >= self.CFScrollView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            } else if (bottomEdge < self.CFScrollView.contentSize.height - 10)
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
    
    func viewMore(){
        HAZT.sizeToFit()
        RIST.sizeToFit()
        SAFT.sizeToFit()
        
        haz.sizeToFit()
        risk.sizeToFit()
        safety.sizeToFit()
        
        contentView.sizeToFit()
        CFScrollView.sizeToFit()
        
        let cont1 = HAZT.frame.height + RIST.frame.height + SAFT.frame.height
        let cont2 = haz.frame.height + risk.frame.height + safety.frame.height
        
        let conT = cont1 + cont2 + 40
        
        //check if the real content height is over or less the content view height
         if (contentView.frame.height > CFScrollView.frame.height) {

             self.viewMoreLbl.isHidden = false
             self.scrollDownArrow.isHidden = false
         } else if (contentView.frame.height < CFScrollView.frame.height) {
             if (CFScrollView.frame.height < conT) {
                 self.viewMoreLbl.isHidden = false
                 self.scrollDownArrow.isHidden = false
             } else {
                 self.viewMoreLbl.isHidden = true
                 self.scrollDownArrow.isHidden = true
             }
         } else if (contentView.frame.height == CFScrollView.frame.height) {
             if (CFScrollView.frame.height < conT) {
                 self.viewMoreLbl.isHidden = false
                 self.scrollDownArrow.isHidden = false
             } else {
                 self.viewMoreLbl.isHidden = true
                 self.scrollDownArrow.isHidden = true
             }
         }
    }

}
