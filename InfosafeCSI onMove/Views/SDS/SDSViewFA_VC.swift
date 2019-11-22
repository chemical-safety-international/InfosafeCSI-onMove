//
//  SDSViewFA_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewFA_VC: UIViewController, UIScrollViewDelegate {


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
    
    @IBOutlet weak var INHinhGap: NSLayoutConstraint!
    @IBOutlet weak var inhINGGap: NSLayoutConstraint!
    @IBOutlet weak var INGingGao: NSLayoutConstraint!
    @IBOutlet weak var ingSKIGap: NSLayoutConstraint!
    @IBOutlet weak var SkiskiGap: NSLayoutConstraint!
    @IBOutlet weak var skiEYEGap: NSLayoutConstraint!
    @IBOutlet weak var EYEeyeGap: NSLayoutConstraint!
    @IBOutlet weak var eyeFAFGap: NSLayoutConstraint!
    @IBOutlet weak var FAFfafGap: NSLayoutConstraint!
    @IBOutlet weak var fafATDGap: NSLayoutConstraint!
    @IBOutlet weak var ATDatdGap: NSLayoutConstraint!
    
    
    
    private var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        setTitlesLayout()
        // Do any additional setup after loading the view.
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        FAScrollView.sizeToFit()
        let bottomEdge = FAScrollView.contentOffset.y + FAScrollView.frame.size.height
        
        DispatchQueue.main.async {
            if (bottomEdge >= self.FAScrollView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
//            } else if (bottomEdge < self.FAScrollView.contentSize.height - 10)
//            {
//                self.viewMore()
            }
        }
    }
 
    // control scroll down label to display when going up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("last: \(lastContentOffset)")
//        print(scrollView.contentOffset.y)
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            print("going up")
           let bottomEdge = FAScrollView.contentOffset.y + FAScrollView.frame.size.height
            DispatchQueue.main.async {
                if (bottomEdge <= self.FAScrollView.contentSize.height - 10)
                {
                    self.viewMoreLbl.isHidden = false
                    self.scrollDownArrow.isHidden = false
                }
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    //detect the rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.viewMore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.viewMore()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
    }
    
    func callFA() {

//        csiWCF_VM().callSDS_FA() { (output) in
//            if output.contains("true") {

                self.getValue()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
//            }else {
//                print("Something wrong!")
//            }
//
//        }
    }
    
    func getValue() {
//        DispatchQueue.main.async {
            
            if (localViewSDSFA.inhalation.isEmpty == false) {
                self.inh.text = localViewSDSFA.inhalation
            } else {
                self.INHT.text = ""
                self.inh.text = ""
                self.INHinhGap.constant = 0

            }
            
            if (localViewSDSFA.ingestion.isEmpty == false) {
                self.ing.text = localViewSDSFA.ingestion
            } else {
                self.INGT.text = ""
                self.ing.text = ""
                self.inhINGGap.constant = 0
                self.INGingGao.constant = 0
            }
            
            if (localViewSDSFA.skin.isEmpty == false) {
                self.skin.text = localViewSDSFA.skin
            } else {
                self.SKINT.text = ""
                self.skin.text = ""
                self.ingSKIGap.constant = 0
                self.SkiskiGap.constant = 0
            }
            
            if (localViewSDSFA.eye.isEmpty == false) {
                self.eye.text = localViewSDSFA.eye
            } else {
                self.EYET.text = ""
                self.eye.text = ""
                self.skiEYEGap.constant = 0
                self.EYEeyeGap.constant = 0
            }
            
            if (localViewSDSFA.fafacilities.isEmpty == false) {
                self.faf.text = localViewSDSFA.fafacilities
            } else {
                self.FAFT.text = ""
                self.faf.text = ""
                self.eyeFAFGap.constant = 0
                self.FAFfafGap.constant = 0
            }
            
            if (localViewSDSFA.advdoctor.isEmpty == false) {
                self.atd.text = localViewSDSFA.advdoctor
            } else {
                self.ATDT.text = ""
                self.atd.text = ""
                self.fafATDGap.constant = 0
                self.ATDatdGap.constant = 0
            }
            
        DispatchQueue.main.async {
            self.viewMore()
        }
            
            self.FAScrollView.isHidden = false
//        }
    }
    
    func viewMore() {
        
        DispatchQueue.main.async {
//            self.INHT.sizeToFit()
//            self.INGT.sizeToFit()
//            self.SKINT.sizeToFit()
//            self.EYET.sizeToFit()
//            self.FAFT.sizeToFit()
//            self.ATDT.sizeToFit()
//            
//            self.inh.sizeToFit()
//            self.ing.sizeToFit()
//            self.skin.sizeToFit()
//            self.eye.sizeToFit()
//            self.faf.sizeToFit()
//            self.atd.sizeToFit()
            
            let count1 = self.INHT.frame.height + self.INGT.frame.height + self.SKINT.frame.height + self.EYET.frame.height
            let count2 = self.FAFT.frame.height + self.ATDT.frame.height + self.inh.frame.height + self.ing.frame.height
            let count3 = self.skin.frame.height + self.eye.frame.height + self.faf.frame.height + self.atd.frame.height
            let count4 = self.INHinhGap.constant + self.inhINGGap.constant + self.INGingGao.constant + self.ingSKIGap.constant
            let count5 = self.SkiskiGap.constant + self.skiEYEGap.constant + self.EYEeyeGap.constant + self.eyeFAFGap.constant
            let count6 = self.FAFfafGap.constant + self.fafATDGap.constant + self.ATDatdGap.constant
            
            let conT = count1 + count2 + count3 + count4 + count5 + count6 + 20

//            print(self.contentView.frame.height)
//            print(self.FAScrollView.frame.height)
//            print(conT)
//            print("\n")
            
            //check if the real content height is over or less the content view height
//        DispatchQueue.main.async {
            if conT > self.FAScrollView.frame.height {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }
//        }
        }

        

        
//        if (contentView.frame.height > FAScrollView.frame.height) {
//
//            self.viewMoreLbl.isHidden = false
//            self.scrollDownArrow.isHidden = false
//        } else if (contentView.frame.height < FAScrollView.frame.height) {
//            if (FAScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//            } else if (FAScrollView.frame.height - conT <= 50.0) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//            } else {
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//            }
//        } else if (contentView.frame.height == FAScrollView.frame.height) {
//            if (FAScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//            } else {
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//            }
//        }
    }
    
    func setTitlesLayout() {
        INHT.layer.masksToBounds = true
        INHT.backgroundColor = UIColor(red:0.04, green:0.56, blue:0.13, alpha:1.0)
        INHT.layer.cornerRadius = 8
        
        INGT.layer.masksToBounds = true
        INGT.backgroundColor = UIColor(red:0.04, green:0.56, blue:0.13, alpha:1.0)
        INGT.layer.cornerRadius = 8
        
        SKINT.layer.masksToBounds = true
        SKINT.backgroundColor = UIColor(red:0.04, green:0.56, blue:0.13, alpha:1.0)
        SKINT.layer.cornerRadius = 8
        
        EYET.layer.masksToBounds = true
        EYET.backgroundColor = UIColor(red:0.04, green:0.56, blue:0.13, alpha:1.0)
        EYET.layer.cornerRadius = 8
        
        FAFT.layer.masksToBounds = true
        FAFT.backgroundColor = UIColor(red:0.04, green:0.56, blue:0.13, alpha:1.0)
        FAFT.layer.cornerRadius = 8
        
        ATDT.layer.masksToBounds = true
        ATDT.backgroundColor = UIColor(red:0.04, green:0.56, blue:0.13, alpha:1.0)
        ATDT.layer.cornerRadius = 8
    }


}
