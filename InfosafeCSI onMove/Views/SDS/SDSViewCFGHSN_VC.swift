//
//  SDSViewCFGHSN_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 15/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewCFGHSN_VC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var ClassF: UILabel!
    
    @IBOutlet weak var GHSClassT: UILabel!
    @IBOutlet weak var HazardST: UILabel!
    @IBOutlet weak var PercauT: UILabel!
    @IBOutlet weak var PST: UILabel!
    @IBOutlet weak var DanGT: UILabel!
    @IBOutlet weak var PTGT: UILabel!
    
    @IBOutlet weak var ghsclass: UILabel!
    @IBOutlet weak var haz: UILabel!
    @IBOutlet weak var pstate: UILabel!
    @IBOutlet weak var ps: UILabel!
    @IBOutlet weak var dang: UILabel!
    @IBOutlet weak var ptg: UILabel!
        
        
    @IBOutlet weak var GHSScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewMoreLbl: UILabel!
    @IBOutlet weak var scrollDownArrow: UIImageView!
        
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var all: UIButton!
    @IBOutlet weak var ghsBtn: UIButton!
    @IBOutlet weak var hazBtn: UIButton!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var dpBtn: UIButton!
    
    
    @IBOutlet weak var picImgGap: NSLayoutConstraint!
    @IBOutlet weak var picImgGap2: NSLayoutConstraint!
    @IBOutlet weak var imgGHSGap: NSLayoutConstraint!
    @IBOutlet weak var ghsHazGap: NSLayoutConstraint!
    @IBOutlet weak var hazPreGap: NSLayoutConstraint!
    @IBOutlet weak var prePSGap: NSLayoutConstraint!
    
    private var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.removeSpinner()
        
        //set the bold text for title texts
        ClassF.font = UIFont.boldSystemFont(ofSize: 25)
        GHSClassT.font = UIFont.boldSystemFont(ofSize: 16)
        HazardST.font = UIFont.boldSystemFont(ofSize: 16)
        PercauT.font = UIFont.boldSystemFont(ofSize: 16)
        PST.font = UIFont.boldSystemFont(ofSize: 16)
        DanGT.font = UIFont.boldSystemFont(ofSize: 16)
        PTGT.font = UIFont.boldSystemFont(ofSize: 16)
        
        GHSScrollView.delegate = self
        
        GHSScrollView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        

        callSDSGHS()

    }
    
    
    func callSDSGHS() {
        
        getValue()
    }
    
    func getValue() {
        DispatchQueue.main.async {
            self.ghsclass.text = localViewSDSGHS.classification
            self.haz.text = localViewSDSGHS.hstate
            self.pstate.text = localViewSDSGHS.pstate
            self.ps.text = localViewSDSGHS.ps
            self.dang.text = localViewSDSGHS.dg
            self.ptg.text = localViewSDSGHS.pic
            
            self.all.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            self.viewMore()
            //set the collection view height same as it expanded
            self.setImage()

            self.GHSScrollView.isHidden = false

        }
        all.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        ghsBtn.setTitleColor(UIColor.white, for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        dpBtn.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        GHSScrollView.sizeToFit()
        let bottomEdge = GHSScrollView.contentOffset.y + GHSScrollView.frame.size.height

        DispatchQueue.main.async {

            if (bottomEdge >= self.GHSScrollView.contentSize.height - 10) {

                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
//            } else if (bottomEdge < self.GHSScrollView.contentSize.height - 10)
//            {
//
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
           let bottomEdge = GHSScrollView.contentOffset.y + GHSScrollView.frame.size.height
            DispatchQueue.main.async {
                if (bottomEdge <= self.GHSScrollView.contentSize.height - 10)
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
//            print(self.view.frame.height)
//            print(self.view.frame.width)
            self.viewMore()
            self.setImage()
        }
    }
    
    func viewMore() {
        GHSClassT.sizeToFit()
        HazardST.sizeToFit()
        PercauT.sizeToFit()
        PST.sizeToFit()
        DanGT.sizeToFit()
        
        ghsclass.sizeToFit()
        haz.sizeToFit()
        pstate.sizeToFit()
        ps.sizeToFit()
        dang.sizeToFit()
        ptg.sizeToFit()
        
        img1.sizeToFit()
        img6.sizeToFit()
        
        contentView.sizeToFit()
        GHSScrollView.sizeToFit()

        
        let cont1 = GHSClassT.frame.height + HazardST.frame.height + PercauT.frame.height
        let cont2 = PST.frame.height + DanGT.frame.height + ghsclass.frame.height
        let cont3 = haz.frame.height + pstate.frame.height + ps.frame.height
        let cont4 = dang.frame.height + ptg.frame.height + PTGT.frame.height
        let cont5 = img1.frame.height + img6.frame.height/2 + prePSGap.constant
        let cont6 = picImgGap.constant + imgGHSGap.constant + ghsHazGap.constant + hazPreGap.constant
        
        let conT = cont1 + cont2 + cont3 + cont4 + cont5 + cont6 + 35
        
        
        print("contentView height: \(contentView.frame.height)\n scrollView height: \(GHSScrollView.frame.height)\n conT height: \(conT)\n")
        //check if the real content height is over or less the content view height
        if (contentView.frame.height > GHSScrollView.frame.height) {
            if (GHSScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
               self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }

        } else if (contentView.frame.height < GHSScrollView.frame.height) {
            if (GHSScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }
        } else if (contentView.frame.height == GHSScrollView.frame.height) {
            if (GHSScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            }
        }
        view.reloadInputViews()
    }
    
    func setImage() {
        
        if localViewSDSGHS.picArray.count != 0 {
            var cArray: [Any] = []
            var imgCode: String!

            for index in 0..<(localViewSDSGHS.picArray!.count) {

                let imgName = localViewSDSGHS.picArray![index]
                let imgNameFix = (imgName as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)

                if (imgNameFix == "Flame") {

                    imgCode = "GHS02"
                    
                } else if (imgNameFix == "Skull and crossbones") {

                    imgCode = "GHS06"

                } else if (imgNameFix == "Flame over circle") {

                    imgCode = "GHS03"

                } else if (imgNameFix == "Exclamation mark") {

                    imgCode = "GHS07"

                } else if (imgNameFix == "Environment") {

                    imgCode = "GHS09"

                } else if (imgNameFix == "Health hazard") {

                    imgCode = "GHS08"

                } else if (imgNameFix == "Corrosion") {

                    imgCode = "GHS05"

                } else if (imgNameFix == "Gas cylinder") {

                    imgCode = "GHS04"

                } else if (imgNameFix == "Exploding bomb") {

                    imgCode = "GHS01"
                }

                cArray.append(imgCode!)
            }

            if cArray.count == 1 {
                img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)

            } else if cArray.count == 2 {
                img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
            } else if cArray.count == 3 {
                img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
            } else if cArray.count == 4 {
                view.sizeToFit()
                if (view.frame.height < 1024) {
                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                    img6.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
                } else {
                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                    img4.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
                }
            } else if cArray.count == 5 {

                view.sizeToFit()
                //below iphone 11 pro max, width all less than 414
                if (view.frame.width <= 414) {
 
                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                    img6.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
                    img7.image = UIImage(named: Bundle.main.path(forResource: cArray[4] as? String, ofType: "png")!)
                    img4.image = nil
                    img5.image = nil
                    
                } else {

                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                    img4.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
                    img5.image = UIImage(named: Bundle.main.path(forResource: cArray[4] as? String, ofType: "png")!)
                    img6.image = nil
                    img7.image = nil
                }
            }
        }

    }

    
    @IBAction func allBtnTapped(_ sender: Any) {
            
        setImage()
        imgHeight.constant = 90
        imgWidth.constant = 90
        
        PTGT.text = "PICTOGRAM (S)"
        GHSClassT.text = "GHS CLASSFICATION OF THE SUBSTANCE/MIXTURE"
        HazardST.text = "HAZARD STATEMENT(S)"
        PST.text = "POISONS SCHEDULE"
        PercauT.text = "PRECAUTIONARY STATEMENT (S)"
        DanGT.text = "DANGEROUS GOODS"
        
        self.ghsclass.text = localViewSDSGHS.classification
        self.haz.text = localViewSDSGHS.hstate
        self.pstate.text = localViewSDSGHS.pstate
        self.ps.text = localViewSDSGHS.ps
        self.dang.text = localViewSDSGHS.dg
        self.ptg.text = localViewSDSGHS.pic
        
        picImgGap.constant = 10
        picImgGap2.constant = 58
        imgGHSGap.constant = 10
        ghsHazGap.constant = 10
        hazPreGap.constant = 10
        prePSGap.constant = 10
        
        self.all.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.hazBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        all.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        ghsBtn.setTitleColor(UIColor.white, for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        dpBtn.setTitleColor(UIColor.white, for: .normal)
        
        viewMore()

    }
        
    @IBAction func ghsBtnTapped(_ sender: Any) {

        
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        
        imgHeight.constant = 0
        imgWidth.constant = 0
        
        PTGT.text = ""
        GHSClassT.text = "GHS CLASSFICATION OF THE SUBSTANCE/MIXTURE"
        HazardST.text = ""
        PST.text = ""
        PercauT.text = ""
        DanGT.text = ""
        
        self.ghsclass.text = localViewSDSGHS.classification
        self.haz.text = ""
        self.pstate.text = ""
        self.ps.text = ""
        self.dang.text = ""
        self.ptg.text = ""
        
        picImgGap.constant = 0
        picImgGap2.constant = 0
        imgGHSGap.constant = 0
        ghsHazGap.constant = 0
        hazPreGap.constant = 0
        prePSGap.constant = 0
        
        self.all.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.hazBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        all.setTitleColor(UIColor.white, for: .normal)
        ghsBtn.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        dpBtn.setTitleColor(UIColor.white, for: .normal)
        
        viewMore()

    }
        
    @IBAction func hazBtnTapped(_ sender: Any) {
        
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        
        imgHeight.constant = 0
        imgWidth.constant = 0
        
        PTGT.text = ""
        GHSClassT.text = ""
        HazardST.text = "HAZARD STATEMENT(S)"
        PST.text = ""
        PercauT.text = ""
        DanGT.text = ""
        
        self.ghsclass.text = ""
        self.haz.text = localViewSDSGHS.hstate
        self.pstate.text = ""
        self.ps.text = ""
        self.dang.text = ""
        self.ptg.text = ""
        
        picImgGap.constant = 0
        picImgGap2.constant = 0
        imgGHSGap.constant = 0
        ghsHazGap.constant = 0
        hazPreGap.constant = 0
        prePSGap.constant = 0
        
        self.all.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.hazBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        all.setTitleColor(UIColor.white, for: .normal)
        ghsBtn.setTitleColor(UIColor.white, for: .normal)
        hazBtn.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        dpBtn.setTitleColor(UIColor.white, for: .normal)
        viewMore()

    }
    
    @IBAction func preBtnTapped(_ sender: Any) {
         
         img1.image = nil
         img2.image = nil
         img3.image = nil
         img4.image = nil
         img5.image = nil
         img6.image = nil
         img7.image = nil
         
         imgHeight.constant = 0
         imgWidth.constant = 0
         
         PTGT.text = ""
         GHSClassT.text = ""
         HazardST.text = ""
         PST.text = ""
         PercauT.text = "PRECAUTIONARY STATEMENT (S)"
         DanGT.text = ""
         
         self.ghsclass.text = ""
        self.haz.text = ""
         self.pstate.text = localViewSDSGHS.pstate
         self.ps.text = ""
         self.dang.text = ""
         self.ptg.text = ""
        
        picImgGap.constant = 0
        picImgGap2.constant = 0
        imgGHSGap.constant = 0
        ghsHazGap.constant = 0
        hazPreGap.constant = 0
        prePSGap.constant = 0
        
        self.all.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.hazBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.dpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        all.setTitleColor(UIColor.white, for: .normal)
        ghsBtn.setTitleColor(UIColor.white, for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        dpBtn.setTitleColor(UIColor.white, for: .normal)
        viewMore()
    }
    
    @IBAction func dpBtnTapped(_ sender: Any) {
         
         img1.image = nil
         img2.image = nil
         img3.image = nil
         img4.image = nil
         img5.image = nil
         img6.image = nil
         img7.image = nil
         
          imgHeight.constant = 0
          imgWidth.constant = 0
          
          PTGT.text = ""
          GHSClassT.text = ""
          HazardST.text = ""
          PST.text = "POISONS SCHEDULE"
          PercauT.text = ""
          DanGT.text = "DANGEROUS GOODS"
          
          self.ghsclass.text = ""
         self.haz.text = ""
          self.pstate.text = ""
          self.ps.text = localViewSDSGHS.ps
          self.dang.text = localViewSDSGHS.dg
          self.ptg.text = ""
        
        picImgGap.constant = 0
        picImgGap2.constant = 0
        imgGHSGap.constant = 0
        ghsHazGap.constant = 0
        hazPreGap.constant = 0
        prePSGap.constant = 0
        
        self.all.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.hazBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        
        all.setTitleColor(UIColor.white, for: .normal)
        ghsBtn.setTitleColor(UIColor.white, for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        dpBtn.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        viewMore()
    }
    
}
