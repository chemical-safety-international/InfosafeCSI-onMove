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
    @IBOutlet weak var SKIskiGap: UILabel!
    
    
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
    
    func callFA() {

        csiWCF_VM().callSDS_FA() { (output) in
            if output.contains("true") {

                self.getValue()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
            }else {
                print("Something wrong!")
            }
            
        }
    }
    
    func getValue() {
        DispatchQueue.main.async {
            
            if (localViewSDSFA.inhalation.isEmpty == false) {
                self.inh.text = localViewSDSFA.inhalation
            } else {
                self.INHT.text = ""
                self.inh.text = ""
            }
            
            if (localViewSDSFA.ingestion.isEmpty == false) {
                self.ing.text = localViewSDSFA.ingestion
            } else {
                self.INGT.text = ""
                self.ing.text = ""
            }
            
            if (localViewSDSFA.skin.isEmpty == false) {
                self.skin.text = localViewSDSFA.skin
            } else {
                self.SKINT.text = ""
                self.skin.text = ""
            }
            
            if (localViewSDSFA.eye.isEmpty == false) {
                self.eye.text = localViewSDSFA.eye
            } else {
                self.EYET.text = ""
                self.eye.text = ""
            }
            
            if (localViewSDSFA.fafacilities.isEmpty == false) {
                self.faf.text = localViewSDSFA.fafacilities
            } else {
                self.FAFT.text = ""
                self.faf.text = ""
            }
            
            if (localViewSDSFA.advdoctor.isEmpty == false) {
                self.atd.text = localViewSDSFA.advdoctor
            } else {
                self.ATDT.text = ""
                self.atd.text = ""
            }
            
   
            
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
        
        let conT = cont1 + cont2 + cont3 + 180

//        print(contentView.frame.height)
//        print(FAScrollView.frame.height)
//        print(conT)
//        print("\n")
        
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
