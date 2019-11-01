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
    

    
    @IBOutlet weak var ghsclass: UILabel!
    @IBOutlet weak var haz: UILabel!
    @IBOutlet weak var pstate: UILabel!
    @IBOutlet weak var ps: UILabel!

    @IBOutlet weak var unno: UILabel!
    @IBOutlet weak var pg: UILabel!
    @IBOutlet weak var hc: UILabel!
    @IBOutlet weak var psn: UILabel!
    @IBOutlet weak var dgImg: UIImageView!
    
        
        
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
    @IBOutlet weak var hazBtn: UIButton!
    @IBOutlet weak var preBtn: UIButton!

    
    

    @IBOutlet weak var ghsImgGap: NSLayoutConstraint!
    @IBOutlet weak var imgGhsGap: NSLayoutConstraint!
    @IBOutlet weak var ghsImgGap2: NSLayoutConstraint!
    @IBOutlet weak var ghsHazGap: NSLayoutConstraint!
    @IBOutlet weak var hazPreGap: NSLayoutConstraint!
    
    @IBOutlet weak var preTiGap: NSLayoutConstraint!
    @IBOutlet weak var tiDgimgGap: NSLayoutConstraint!
    @IBOutlet weak var unPgGap: NSLayoutConstraint!
    @IBOutlet weak var pgHcGap: NSLayoutConstraint!
    @IBOutlet weak var hcProGap: NSLayoutConstraint!
    @IBOutlet weak var proPsGap: NSLayoutConstraint!
    
    @IBOutlet weak var dgImgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewSDSBTn: UIButton!
    
    @IBOutlet weak var dgBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    private var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.removeSpinner()
        
        //set the bold text for title texts
        GHSClassT.font = UIFont.boldSystemFont(ofSize: 16)
        HazardST.font = UIFont.boldSystemFont(ofSize: 16)
        PercauT.font = UIFont.boldSystemFont(ofSize: 16)
        PST.font = UIFont.boldSystemFont(ofSize: 16)
        TIT.font = UIFont.boldSystemFont(ofSize: 16)


        
        GHSScrollView.delegate = self
        
        GHSScrollView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        
//        self.view.backgroundColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
        
        setCFTIValue()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }
    
    func setNavBar() {
        //change background color & back button color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //change navigation bar text color and font
        navigationItem.title = "CLASSIFICATION"
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
            let unStr = "UNNO: "
            let pgStr = "PG: "
            let hcStr = "Hazchem Code "
            let psnStr = "Proper Shipping Name "
            
            self.GHSClassT.text = "GHS CLASSFICATION"
            self.PST.text = "POISONS SCHEDULE"
            self.TIT.text = "DANGEROUS GOODS"
            self.PST.text = "POISON SCHEDULE"
            
            self.HazardST.text = ""
            self.PercauT.text = ""
            
            self.ghsHazGap.constant = 0
            self.hazPreGap.constant = 0
            
//            if (self.img1.image != nil) {
                if (self.img6.image == nil) {
                    self.ghsImgGap2.constant = 10
                } else {
                   self.ghsImgGap2.constant = 58
                }
//            }

            
            self.GHSScrollView.isHidden = false
            self.containerView.isHidden = true
            
            
            self.ghsclass.text = localViewSDSGHS.classification
            self.haz.text = ""
            self.pstate.text = ""
            self.ps.text = localViewSDSGHS.ps
            
            self.preTiGap.constant = 20
            self.tiDgimgGap.constant = 20
            self.unPgGap.constant = 5
            self.pgHcGap.constant = 5
            self.hcProGap.constant = 5
//            self.proPsGap.constant = 20
            
            self.unno.text = unStr + localViewSDSTIADG.road_unno
            self.pg.text = pgStr + localViewSDSTIADG.road_packgrp
            self.hc.text = hcStr + localViewSDSTIADG.road_hazchem
            self.psn.text = psnStr + localViewSDSTIADG.road_psn

            
            self.viewMore()
            //set the collection view height same as it expanded
            self.imgHeight.constant = 90
            self.imgWidth.constant = 90
            self.dgImgHeight.constant = 90
            self.setImage()

            self.GHSScrollView.isHidden = false

        }
        
        self.all.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.hazBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
//        all.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        
//        all.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1)
//        hazBtn.layer.sublayers?.removeAll()
//        preBtn.layer.sublayers?.removeAll()
        
        GHSClassT.layer.addBorder(edge: UIRectEdge.top, color: UIColor.orange, thickness: 1)
        GHSClassT.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.orange, thickness: 1)
        TIT.layer.addBorder(edge: UIRectEdge.top, color: UIColor.orange, thickness: 1)
        TIT.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.orange, thickness: 1)
        PST.layer.addBorder(edge: UIRectEdge.top, color: UIColor.orange, thickness: 1)
        PST.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.orange, thickness: 1)

        
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
        GHSClassT.sizeToFit()
        HazardST.sizeToFit()
        PercauT.sizeToFit()
        PST.sizeToFit()
        TIT.sizeToFit()
        
        ghsclass.sizeToFit()
        haz.sizeToFit()
        pstate.sizeToFit()
        ps.sizeToFit()
        
        unno.sizeToFit()
        pg.sizeToFit()
        hc.sizeToFit()
        psn.sizeToFit()

        img1.sizeToFit()
        img6.sizeToFit()
        dgImg.sizeToFit()
        
        contentView.sizeToFit()
        GHSScrollView.sizeToFit()
    

        
//        let cont1 = GHSClassT.frame.height + HazardST.frame.height + PercauT.frame.height
//        let cont2 = PST.frame.height + ghsclass.frame.height + TIT.frame.height
//        let cont3 = haz.frame.height + pstate.frame.height + ps.frame.height
//        var cont4 = unno.frame.height + pg.frame.height + hc.frame.height + psn.frame.height
//        let cont5 = img1.frame.height + img6.frame.height/2 + ghsImgGap2.constant
//        let cont6 = imgGhsGap.constant + ghsHazGap.constant + hazPreGap.constant
//        let cont7 = preTiGap.constant + tiDgimgGap.constant + proPsGap.constant
        
//        if cont4 != 0{
//            if (cont4 < 90) {
//                cont4 = 90
//            }
//        }

        
//        let conT = cont1 + cont2 + cont3 + cont4 + cont5 + cont6 + cont7 + 15
        
        
        
//        print("contentView height: \(contentView.frame.height)\n scrollView height: \(GHSScrollView.frame.height)\n conT height: \(conT)\n")
//        print("cont1 : \(cont1)\ncont2 : \(cont2)\ncont3 : \(cont3)\ncont4 : \(cont4)\ncont5 : \(cont5)\ncont6 : \(cont6)\ncont7 : \(cont7)\n")
        
        //check if the real content height is over or less the content view height
//        if (contentView.frame.height > GHSScrollView.frame.height) {
//            if (GHSScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//            } else {
//               self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//            }
//
//        } else if (contentView.frame.height < GHSScrollView.frame.height) {
//            if (GHSScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//            } else {
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//            }
//        } else if (contentView.frame.height == GHSScrollView.frame.height) {
//            if (GHSScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//            } else {
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//            }
//        }
//        view.reloadInputViews()
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

    
    @IBAction func allBtnTapped(_ sender: Any) {
            
        getValue()

    }
        
    @IBAction func hazBtnTapped(_ sender: Any) {
        
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        dgImg.image = nil
        
        imgHeight.constant = 0
        imgWidth.constant = 0
        

        GHSClassT.text = ""
        HazardST.text = "HAZARD STATEMENT(S)"
        PST.text = ""
        PercauT.text = ""
        TIT.text = ""

        
        self.ghsclass.text = ""
        self.haz.text = localViewSDSGHS.hstate
        self.pstate.text = ""
        self.ps.text = ""


        
//        ghsImgGap.constant = 0
//        ghsImgGap2.constant = 0
//        imgGhsGap.constant = 0
//        ghsHazGap.constant = 0
//        hazPreGap.constant = 0
//        
//        self.preTiGap.constant = 0
//        self.tiDgimgGap.constant = 0
//        self.unPgGap.constant = 0
//        self.pgHcGap.constant = 0
//        self.hcProGap.constant = 0
//        self.proPsGap.constant = 0
//        
//        self.dgImgHeight.constant = 0
        
        self.unno.text = ""
        self.pg.text = ""
        self.hc.text = ""
        self.psn.text = ""

        
        self.all.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.hazBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        all.setTitleColor(UIColor.white, for: .normal)
//        hazBtn.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor.white, for: .normal)
        
        hazBtn.backgroundColor = UIColor.orange
        all.backgroundColor = UIColor.darkGray
        

//        hazBtn.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1)
//        all.layer.sublayers?.removeAll()
//        preBtn.layer.sublayers?.removeAll()
        
        TIT.layer.sublayers?.removeAll()
        PST.layer.sublayers?.removeAll()
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
    dgImg.image = nil
         
//        imgHeight.constant = 0
//        imgWidth.constant = 0
         

        GHSClassT.text = ""
        HazardST.text = ""
        PST.text = ""
        PercauT.text = "PRECAUTIONARY STATEMENT (S)"
        TIT.text = ""

         
        self.ghsclass.text = ""
        self.haz.text = ""
        self.pstate.text = localViewSDSGHS.pstate
        self.ps.text = ""

        
//        ghsImgGap.constant = 0
//        ghsImgGap2.constant = 0
//        imgGhsGap.constant = 0
//        ghsHazGap.constant = 0
//        hazPreGap.constant = 0
//        
//        self.preTiGap.constant = 0
//        self.tiDgimgGap.constant = 0
//        self.unPgGap.constant = 0
//        self.pgHcGap.constant = 0
//        self.hcProGap.constant = 0
//        self.proPsGap.constant = 0
//        
//        self.dgImgHeight.constant = 0
        
        self.unno.text = ""
        self.pg.text = ""
        self.hc.text = ""
        self.psn.text = ""
        
        self.all.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.hazBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.preBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        all.setTitleColor(UIColor.white, for: .normal)
        hazBtn.setTitleColor(UIColor.white, for: .normal)
        preBtn.setTitleColor(UIColor(red:0.91, green:0.53, blue:0.00, alpha:1.0), for: .normal)
        
//        hazBtn.layer.sublayers?.removeAll()
//        all.layer.sublayers?.removeAll()
//        preBtn.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1)
        
        TIT.layer.sublayers?.removeAll()
        PST.layer.sublayers?.removeAll()
        viewMore()
    }
    
    @IBAction func viewSDSBtnTapped(_ sender: Any) {
        
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSViewPage_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }    
    
    @IBAction func dgBtnTapped(_ sender: Any) {
        
        GHSScrollView.isHidden = true
        containerView.isHidden = false
        

        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSTI") as? SDSViewTI_VC
//         self.navigationController?.pushViewController(sdsJump!, animated: true)
        
        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
}
