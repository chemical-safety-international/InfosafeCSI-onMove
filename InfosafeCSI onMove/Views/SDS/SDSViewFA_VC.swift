//
//  SDSViewFA_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewFA_VC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var FAT: UILabel!
    @IBOutlet weak var INHT: UILabel!
    @IBOutlet weak var INGT: UILabel!
    @IBOutlet weak var SKINT: UILabel!
    @IBOutlet weak var EYET: UILabel!
    @IBOutlet weak var FAFT: UILabel!
    @IBOutlet weak var ATDT: UILabel!
    
    
    @IBOutlet weak var inh: UILabel!
    @IBOutlet weak var ing: UILabel!
    @IBOutlet weak var skin: UILabel!
    @IBOutlet weak var eye: UILabel!
    @IBOutlet weak var faf: UILabel!
    @IBOutlet weak var atd: UILabel!
    
    
    @IBOutlet weak var FAScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var viewMoreLbl: UILabel!
    @IBOutlet weak var scrollDownArrow: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        FAT.font = UIFont.boldSystemFont(ofSize: 25)
        INHT.font = UIFont.boldSystemFont(ofSize: 16)
        INGT.font = UIFont.boldSystemFont(ofSize: 16)
        SKINT.font = UIFont.boldSystemFont(ofSize: 16)
        EYET.font = UIFont.boldSystemFont(ofSize: 16)
        FAFT.font = UIFont.boldSystemFont(ofSize: 16)
        ATDT.font = UIFont.boldSystemFont(ofSize: 16)
        
        FAScrollView.delegate = self
        
        FAScrollView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        
        callFA()
        // Do any additional setup after loading the view.
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = FAScrollView.contentOffset.y + FAScrollView.frame.size.height
        FAScrollView.sizeToFit()
        DispatchQueue.main.async {
            if (bottomEdge >= self.FAScrollView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            } else if (bottomEdge < self.FAScrollView.contentSize.height - 10)
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
    
    func callFA() {
        self.showSpinner(onView: self.view)
        csiWCF_VM().callSDS_FA() { (output) in
            if output.contains("true") {

                self.getValue()
                self.removeSpinner()
            }else {
                print("Something wrong!")
            }
            
        }
    }
    
    func getValue() {
        DispatchQueue.main.async {
            self.inh.text = localViewSDSFA.inhalation
            self.ing.text = localViewSDSFA.ingestion
            self.skin.text = localViewSDSFA.skin
            self.eye.text = localViewSDSFA.eye
            self.faf.text = localViewSDSFA.fafacilities
            self.atd.text = localViewSDSFA.advdoctor
            
            self.viewMore()
            self.FAScrollView.isHidden = false
        }
    }
    
    func viewMore() {
        INHT.sizeToFit()
        INGT.sizeToFit()
        SKINT.sizeToFit()
        EYET.sizeToFit()
        FAFT.sizeToFit()
        ATDT.sizeToFit()
        
        inh.sizeToFit()
        ing.sizeToFit()
        skin.sizeToFit()
        eye.sizeToFit()
        faf.sizeToFit()
        atd.sizeToFit()
        
        let cont1 = INHT.frame.height + INGT.frame.height + SKINT.frame.height + EYET.frame.height
        let cont2 = FAFT.frame.height + ATDT.frame.height + inh.frame.height + ing.frame.height
        let cont3 = skin.frame.height + eye.frame.height + faf.frame.height + atd.frame.height
        
        let conT = cont1 + cont2 + cont3 + 70

        print(contentView.frame.height)
        print(FAScrollView.frame.height)
        print(conT)
        print("\n")
        
        //check if the real content height is over or less the content view height
        if (contentView.frame.height > FAScrollView.frame.height) {

            self.viewMoreLbl.isHidden = false
            self.scrollDownArrow.isHidden = false
        } else if (contentView.frame.height < FAScrollView.frame.height) {
            if (FAScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else if (FAScrollView.frame.height - conT <= 50.0) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }
        } else if (contentView.frame.height == FAScrollView.frame.height) {
            if (FAScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }
        }
    }


}
