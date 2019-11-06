//
//  SDSViewCFGHSN_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 15/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewCFGHSN_VC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var GHSClassT: UILabel!
    @IBOutlet weak var HazardST: UILabel!
    @IBOutlet weak var PercauT: UILabel!
    @IBOutlet weak var PST: UILabel!
    @IBOutlet weak var TIT: UILabel!
    
    @IBOutlet weak var UNNOT: UILabel!
    @IBOutlet weak var DGCT: UILabel!
    @IBOutlet weak var SUBRT: UILabel!
    @IBOutlet weak var PGT: UILabel!
    @IBOutlet weak var HCT: UILabel!
    @IBOutlet weak var PSNT: UILabel!
    
    
    @IBOutlet weak var ghsclass: UILabel!
    @IBOutlet weak var haz: UILabel!
    @IBOutlet weak var pstate: UILabel!
    @IBOutlet weak var ps: UILabel!
    @IBOutlet weak var unno: UILabel!
    @IBOutlet weak var pg: UILabel!
    @IBOutlet weak var hc: UILabel!
    @IBOutlet weak var psn: UILabel!
    @IBOutlet weak var dgclass: UILabel!
    @IBOutlet weak var subrisk: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    
    @IBOutlet weak var dgImg: UIImageView!
    @IBOutlet weak var subImg1: UIImageView!
    @IBOutlet weak var subImg2: UIImageView!
  
    @IBOutlet weak var viewSDSBTn: UIButton!
    @IBOutlet weak var preVBtn: UIButton!
    @IBOutlet weak var dgBtn: UIButton!
    @IBOutlet weak var ghsBtn: UIButton!
    @IBOutlet weak var faBtn: UIButton!
    
    
    @IBOutlet weak var viewMoreLbl: UILabel!
    

    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var GHSScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollDownArrow: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hpView: UIView!
    @IBOutlet weak var tiVIew: UIView!
    
    @IBOutlet weak var img1Height: NSLayoutConstraint!
    @IBOutlet weak var img6Height: NSLayoutConstraint!
    
    @IBOutlet weak var ghsImg1Gap: NSLayoutConstraint!
    @IBOutlet weak var ghsImg6Gap: NSLayoutConstraint!
    @IBOutlet weak var ghsHPVGap: NSLayoutConstraint!
//    @IBOutlet weak var hpvTIVGap: NSLayoutConstraint!
    
    @IBOutlet weak var hpHeight: NSLayoutConstraint!
    @IBOutlet weak var tiHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var img6GHSGap: UIView!
    
    
    
    
    
    
    private var lastContentOffset: CGFloat = 0
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.removeSpinner()
        
//        self.view.layoutIfNeeded()
        //set the bold text for title texts
        setTitleBold()

        //set title style
        setTitleStyle()
        
        GHSScrollView.delegate = self
        
        GHSScrollView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        
        setCFTIValue()
        

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.view.layoutIfNeeded()
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }
    
    func setNavBar() {
        //change background color & back button color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //change navigation bar text color and font
//        navigationItem.title = "CLASSIFICATION"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
        
        //remove border for navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setCFTIValue() {
        
        getValue()
    }
    
    func getValue() {
        DispatchQueue.main.async {
            
            self.GHSScrollView.isHidden = false
            self.containerView.isHidden = true
            
            self.ghsclass.text = localViewSDSGHS.classification
            self.ps.text = localViewSDSGHS.ps
            self.unno.text = localViewSDSTIADG.road_unno
            self.pg.text = localViewSDSTIADG.road_packgrp
            self.hc.text = localViewSDSTIADG.road_hazchem
            self.psn.text = localViewSDSTIADG.road_psn
            self.dgclass.text = localViewSDSTIADG.road_dgclass
            self.subrisk.text = localViewSDSTIADG.road_subrisks
            
            self.UNNOT.text = "UNNO:"
            self.DGCT.text = "DG CLASS:"
            self.SUBRT.text = "SUB RISK(S)"
            self.PGT.text = "PACKAGING GROUP"
            self.HCT.text = "HAZCHEM CODE:"
            self.PSNT.text = "PROPER SHIPPING NAME:"
            self.PST.text = "POISONS SCHEDULE"

            
            self.HazardST.text = ""
            self.PercauT.text = ""
            self.haz.text = localViewSDSGHS.hstate
            self.pstate.text = localViewSDSGHS.pstate
            
            
            self.viewMore()
            //set the collection view height same as it expanded

            self.setImage()

            self.GHSScrollView.isHidden = false
            
            self.hpHeight.constant = 0
            self.setTIVHeight()

        }
        
        navigationItem.title = "PREVIEW"
        self.setPreViewBtnStyle()
 
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

            self.viewMore()
            self.setImage()
        }
    }
    
    func viewMore() {
        
        hpView.sizeToFit()
        tiVIew.sizeToFit()
        
        
//        print("hpview: \(hpView.frame.height)\ntiview: \(tiVIew.frame.height)\ncontentview: \(contentView.frame.height)\n ghsscroll: \(GHSScrollView.frame.height)")
        contentView.sizeToFit()
        GHSScrollView.sizeToFit()
        
        
        
        self.view.layoutIfNeeded()
    
        if contentView.frame.height > GHSScrollView.frame.height {
            viewMoreLbl.isHidden = false
            scrollDownArrow.isHidden = false
        } else {
            viewMoreLbl.isHidden = true
            scrollDownArrow.isHidden = true
        }
        
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
        
        var fixStr = ""
        
        if localViewSDSTIADG.road_dgclass.isEmpty == true || localViewSDSTIADG.road_dgclass.contains("None") {
            dgImg.image = nil
        } else {
            if (localViewSDSTIADG.road_dgclass.contains(".")) {
                fixStr = localViewSDSTIADG.road_dgclass.replacingOccurrences(of: ".", with: "")
            } else {
                fixStr = localViewSDSTIADG.road_dgclass
            }
            
            self.dgImg.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
        }

    }
    
    func setTitleBold() {
        GHSClassT.font = UIFont.boldSystemFont(ofSize: 18)
        HazardST.font = UIFont.boldSystemFont(ofSize: 18)
        PercauT.font = UIFont.boldSystemFont(ofSize: 18)
        PST.font = UIFont.boldSystemFont(ofSize: 18)
        TIT.font = UIFont.boldSystemFont(ofSize: 18)
        
        UNNOT.font = UIFont.boldSystemFont(ofSize: 16)
        DGCT.font = UIFont.boldSystemFont(ofSize: 16)
        SUBRT.font = UIFont.boldSystemFont(ofSize: 16)
        PGT.font = UIFont.boldSystemFont(ofSize: 16)
        HCT.font = UIFont.boldSystemFont(ofSize: 16)
        PSNT.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    func setTitleStyle() {
        
        GHSClassT.layer.masksToBounds = true
        GHSClassT.backgroundColor = UIColor.orange
        GHSClassT.layer.cornerRadius = 8
        
        HazardST.layer.masksToBounds = true
        HazardST.backgroundColor = UIColor.orange
        HazardST.layer.cornerRadius = 8
        
        PercauT.layer.masksToBounds = true
        PercauT.backgroundColor = UIColor.orange
        PercauT.layer.cornerRadius = 8
        
        HazardST.layer.masksToBounds = true
        HazardST.backgroundColor = UIColor.orange
        HazardST.layer.cornerRadius = 8
        
        HazardST.layer.masksToBounds = true
        HazardST.backgroundColor = UIColor.orange
        HazardST.layer.cornerRadius = 8
        
        TIT.layer.masksToBounds = true
        TIT.backgroundColor = UIColor.orange
        TIT.layer.cornerRadius = 8
        
        PST.layer.masksToBounds = true
        PST.backgroundColor = UIColor.orange
        PST.layer.cornerRadius = 8
        
    }
    
    func setPreViewBtnStyle() {
        self.viewSDSBTn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preVBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.faBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.viewSDSBTn.backgroundColor = UIColor.darkGray
        self.preVBtn.backgroundColor = UIColor.orange
        self.ghsBtn.backgroundColor = UIColor.darkGray
        self.dgBtn.backgroundColor = UIColor.darkGray
        self.faBtn.backgroundColor = UIColor.darkGray
        
        //        GHSClassT.layer.addBorder(edge: UIRectEdge.top, color: UIColor.orange, thickness: 1)
        //        GHSClassT.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.orange, thickness: 1)
        //        TIT.layer.addBorder(edge: UIRectEdge.top, color: UIColor.orange, thickness: 1)
        //        TIT.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.orange, thickness: 1)
        //        PST.layer.addBorder(edge: UIRectEdge.top, color: UIColor.orange, thickness: 1)
        //        PST.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.orange, thickness: 1)
    }
    
    func setViewSDSBtnStyle() {
        self.viewSDSBTn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.preVBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.faBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.viewSDSBTn.backgroundColor = UIColor.orange
        self.preVBtn.backgroundColor = UIColor.darkGray
        self.ghsBtn.backgroundColor = UIColor.darkGray
        self.dgBtn.backgroundColor = UIColor.darkGray
        self.faBtn.backgroundColor = UIColor.darkGray
    }
    
    func setghsBtnStyle() {
        self.viewSDSBTn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preVBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.dgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.faBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.viewSDSBTn.backgroundColor = UIColor.darkGray
        self.preVBtn.backgroundColor = UIColor.darkGray
        self.ghsBtn.backgroundColor = UIColor.orange
        self.dgBtn.backgroundColor = UIColor.darkGray
        self.faBtn.backgroundColor = UIColor.darkGray
    }
    
    func setdgBtnStyle() {
        self.viewSDSBTn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preVBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dgBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.faBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.viewSDSBTn.backgroundColor = UIColor.darkGray
        self.preVBtn.backgroundColor = UIColor.darkGray
        self.ghsBtn.backgroundColor = UIColor.darkGray
        self.dgBtn.backgroundColor = UIColor.orange
        self.faBtn.backgroundColor = UIColor.darkGray
    }
    
    func setfaBtnStyle() {
        self.viewSDSBTn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preVBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.ghsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.dgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.faBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.viewSDSBTn.backgroundColor = UIColor.darkGray
        self.preVBtn.backgroundColor = UIColor.darkGray
        self.ghsBtn.backgroundColor = UIColor.darkGray
        self.dgBtn.backgroundColor = UIColor.darkGray
        self.faBtn.backgroundColor = UIColor.orange
    }
    
    func setHPVHeight() {
        
        HazardST.sizeToFit()
        haz.sizeToFit()
        PercauT.sizeToFit()
        pstate.sizeToFit()
        
        let count = HazardST.frame.height + haz.frame.height + PercauT.frame.height + pstate.frame.height
        
        hpHeight.constant = count + 40

    }
    
    func setTIVHeight() {
        dgImg.sizeToFit()
        subImg1.sizeToFit()
        subImg2.sizeToFit()
        
        TIT.sizeToFit()
        UNNOT.sizeToFit()
        DGCT.sizeToFit()
        SUBRT.sizeToFit()
        PGT.sizeToFit()
        HCT.sizeToFit()
        psn.sizeToFit()
        PST.sizeToFit()
        ps.sizeToFit()
        
//        let count1 = subImg1.frame.height + subImg2.frame.height + UNNOT.frame.height + DGCT.frame.height
        let count1 = 130 + UNNOT.frame.height + DGCT.frame.height
        let count2 = SUBRT.frame.height + PGT.frame.height + HCT.frame.height + psn.frame.height
        let count3 = PST.frame.height + ps.frame.height + TIT.frame.height
        
        tiHeight.constant = count1 + count2 + count3 + 110
        print(count1)
        print(count2)
        print(count3)
        print(tiHeight.constant)
    }

    
    @IBAction func allBtnTapped(_ sender: Any) {
            
        getValue()

    }
        
    @IBAction func ghsBtnTapped(_ sender: Any) {
        
        setghsBtnStyle()
        
        GHSScrollView.isHidden = false
        containerView.isHidden = true
        
        navigationItem.title = "GHS"
        
        dgImg.image = nil
        subImg1.image = nil
        subImg2.image = nil
        
        self.HazardST.text = "HAZARD STATEMENT(S)"
        self.PercauT.text = "PRECAUTIONARY STATEMENT(S)"
        self.haz.text = localViewSDSGHS.hstate
        self.pstate.text = localViewSDSGHS.pstate
        
        self.UNNOT.text = ""
        self.DGCT.text = ""
        self.SUBRT.text = ""
        self.PGT.text = ""
        self.HCT.text = ""
        self.PSNT.text = ""
        self.PST.text = ""
        
        self.unno.text = ""
        self.pg.text = ""
        self.hc.text = ""
        self.psn.text = ""
        self.dgclass.text = ""
        self.subrisk.text = ""
        self.ps.text = ""
        
//        self.hpHeight.constant = self.oriHPVHeight
        self.tiHeight.constant = 0
        self.setHPVHeight()
        
        viewMore()

    }
    

    
    @IBAction func viewSDSBtnTapped(_ sender: Any) {
        
//        setViewSDSBtnStyle()
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSViewPage_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    
    @IBAction func dgBtnTapped(_ sender: Any) {
        
        setdgBtnStyle()
        navigationItem.title = "DG CLASS"
        
        GHSScrollView.isHidden = true
        containerView.isHidden = false
        

        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSTI") as? SDSViewTI_VC

        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
    
    
    @IBAction func faBtnTapped(_ sender: Any) {
        
        setfaBtnStyle()
        navigationItem.title = "FIRST AID"
        
        GHSScrollView.isHidden = true
        containerView.isHidden = false
        

        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSFA") as? SDSViewFA_VC
//         self.navigationController?.pushViewController(sdsJump!, animated: true)
        
        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
    
}
