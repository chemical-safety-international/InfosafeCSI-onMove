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
    
    @IBOutlet weak var TIInfo: UILabel!
    
    @IBOutlet weak var ghsclass: UILabel!
    @IBOutlet weak var haz: UILabel!
    @IBOutlet weak var ps: UILabel!
    
    @IBOutlet weak var pstate: UILabel!

    
    
    
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

    
    
    @IBOutlet weak var img1Height: NSLayoutConstraint!
    @IBOutlet weak var img6Height: NSLayoutConstraint!
    
    @IBOutlet weak var ghsImg1Gap: NSLayoutConstraint!
    @IBOutlet weak var ghsImg6Gap: NSLayoutConstraint!
    

    @IBOutlet weak var ghsHazGap: NSLayoutConstraint!
    @IBOutlet weak var HazhazGap: NSLayoutConstraint!
    @IBOutlet weak var hazPreGap: NSLayoutConstraint!
    @IBOutlet weak var PregenGap: NSLayoutConstraint!
 
    
    @IBOutlet weak var TrandgImgGap: NSLayoutConstraint!
    @IBOutlet weak var TransubImg1Gap: NSLayoutConstraint!
    
    @IBOutlet weak var dgImgHeight: NSLayoutConstraint!
    @IBOutlet weak var subImg1height: NSLayoutConstraint!
    
    @IBOutlet weak var subImg1_2Gap: NSLayoutConstraint!
    
    @IBOutlet weak var unPSGap: NSLayoutConstraint!
    @IBOutlet weak var PSpsGap: NSLayoutConstraint!
    
    @IBOutlet weak var img6GHSGap: NSLayoutConstraint!
    
    @IBOutlet weak var dgImgTIInfoGap: NSLayoutConstraint!
    
 
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.loadViewIfNeeded()
//        viewMore()

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
            
//            if (localViewSDSGHS.formatcode == "0F" || localViewSDSGHS.formatcode == "0A") {
//                self.GHSClassT.text = "GHS CLASSFICATION"
//                self.ghsclass.text = localViewSDSGHS.classification
//            } else {
//                self.GHSClassT.text = "RISK PHRASE"
//                self.ghsclass.text = localViewSDSGHS.rphrase
//            }
            
            self.TrandgImgGap.constant = 30
             self.TransubImg1Gap.constant = 10
             self.subImg1_2Gap.constant = 10
             self.dgImgTIInfoGap.constant = 30
             self.unPSGap.constant = 20
             self.PSpsGap.constant = 10
            
            
            self.GHSClassT.text = "GHS CLASSFICATION"
            
            
            
            self.GHSScrollView.isHidden = false
            self.containerView.isHidden = true
            
            
            
            if (localViewSDSGHS.formatcode == "0F" || localViewSDSGHS.formatcode == "0A") {
                if (localViewSDSGHS.ps.isEmpty == false) {
                    self.PST.text = "POISONS SCHEDULE"
                    self.ps.text = localViewSDSGHS.ps
                    self.unPSGap.constant = 20
                    self.PSpsGap.constant = 10
                    
                } else {
                    self.PST.text = ""
                    self.ps.text = ""
                    self.unPSGap.constant = 0
                    self.PSpsGap.constant = 0
                }
                
                if (localViewSDSGHS.classification.isEmpty == false) {
                    self.ghsclass.text = localViewSDSGHS.classification
                } else {
                    self.ghsclass.text = "None."
                }
            } else {
                if (localViewSDSCF.ps != nil) {
                    self.PST.text = "POISONS SCHEDULE"
                    self.ps.text = localViewSDSCF.ps
                    self.unPSGap.constant = 20
                    self.PSpsGap.constant = 10
                    
                
                } else {
                    self.PST.text = ""
                    self.ps.text = ""
                    self.unPSGap.constant = 0
                    self.PSpsGap.constant = 0
                }
                
                if (localViewSDSCF.classification.isEmpty == false) {
                    self.ghsclass.text = localViewSDSCF.classification
                } else {
                    self.ghsclass.text = "None."
                }
            }
            

            
            self.TIT.text = "TRANSPORT INFORMATION"
            
            let tiStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
            let breakStr: NSMutableAttributedString = NSMutableAttributedString(string: "\n")
            
            if localViewSDSTIADG.road_unno.isEmpty == false {
                let str = "\nUNNO:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSTIADG.road_unno)
                
                
                tiStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                tiStr.append(strdata)
                tiStr.append(breakStr)
            }
            
            if localViewSDSTIADG.road_dgclass.isEmpty == false {
                let str = "\nDG CLASS:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSTIADG.road_dgclass)
                
                
                tiStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                tiStr.append(strdata)
                tiStr.append(breakStr)
            }
            
            if localViewSDSTIADG.road_subrisks.isEmpty == false {
                let str = "\nSUB RISK(S):\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSTIADG.road_subrisks)
                
                
                tiStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                tiStr.append(strdata)
                tiStr.append(breakStr)
            }
            
            if localViewSDSTIADG.road_packgrp.isEmpty == false {
                let str = "\nHAZCHEM CODE:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSTIADG.road_packgrp)
                
                
                tiStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                tiStr.append(strdata)
                tiStr.append(breakStr)
            }
            
            if localViewSDSTIADG.road_hazchem.isEmpty == false {
                let str = "\nPACKAGING GROUP:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSTIADG.road_hazchem)
                
                
                tiStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                tiStr.append(strdata)
                tiStr.append(breakStr)
            }
            
            if localViewSDSTIADG.road_psn.isEmpty == false {
                let str = "\nPROPER SHIPPING NAME:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSTIADG.road_psn)
                
                
                tiStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                tiStr.append(strdata)
                tiStr.append(breakStr)
            }
            
            


            
            self.TIInfo.attributedText = tiStr
    
            if (tiStr == NSMutableAttributedString(string: "")) {
                self.TIInfo.text = ""
                
            }
            
            self.HazardST.text = ""
            self.PercauT.text = ""
            self.haz.text = ""
            self.pstate.text = ""

            
            self.HazhazGap.constant = 0
            self.hazPreGap.constant = 0
            self.PregenGap.constant = 0
            
            self.viewMore()
            //set the collection view height same as it expanded

            self.setImage()

            self.GHSScrollView.isHidden = false
            


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
        
        
        
//        print("hpview: \(hpView.frame.height)\ntiview: \(tiVIew.frame.height)\ncontentview: \(contentView.frame.height)\n ghsscroll: \(GHSScrollView.frame.height)")
        DispatchQueue.main.async {
            self.contentView.sizeToFit()
            self.GHSScrollView.sizeToFit()
            
 
            
            self.img1.sizeToFit()
            self.img6.sizeToFit()
            self.ghsclass.sizeToFit()
            self.GHSClassT.sizeToFit()
            self.HazardST.sizeToFit()
            self.haz.sizeToFit()
            self.PercauT.sizeToFit()
            self.pstate.sizeToFit()

            self.TIT.sizeToFit()
            self.dgImg.sizeToFit()
            self.TIInfo.sizeToFit()
            self.PST.sizeToFit()
            self.ps.sizeToFit()
            
            let ct1 = self.img1Height.constant + self.img6Height.constant/2 + self.GHSClassT.frame.height + self.ghsclass.frame.height
            let ct2 = self.HazardST.frame.height + self.haz.frame.height + self.PercauT.frame.height + self.pstate.frame.height
            let ct3 = self.HazhazGap.constant + self.hazPreGap.constant + self.PregenGap.constant + self.dgImgHeight.constant
            let ct4 = self.TIT.frame.height + self.TIInfo.frame.height + self.dgImgTIInfoGap.constant + self.unPSGap.constant
            let ct5 = self.PST.frame.height + self.ps.frame.height + self.PSpsGap.constant
           let ctt = ct1 + ct2 + ct3 + ct4 + ct5 + 100
           
//            print("Ctt: \(ctt)\n")
            
            if ctt > self.GHSScrollView.frame.height {
                 self.viewMoreLbl.isHidden = false
                 self.scrollDownArrow.isHidden = false
             } else {
                 self.viewMoreLbl.isHidden = true
                 self.scrollDownArrow.isHidden = true
             }
        }
//        print(contentView.frame.height)
//        print(GHSScrollView.frame.height)

 
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
                
                img1Height.constant = 90
                ghsImg1Gap.constant = 20
                img6Height.constant = 0
                ghsImg6Gap.constant = 103
                
                img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)

            } else if cArray.count == 2 {
                
                img1Height.constant = 90
                ghsImg1Gap.constant = 20
                img6Height.constant = 0
                ghsImg6Gap.constant = 103
                
                img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
            } else if cArray.count == 3 {
                
                img1Height.constant = 90
                ghsImg1Gap.constant = 20
                img6Height.constant = 0
                ghsImg6Gap.constant = 103
                
                img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
            } else if cArray.count == 4 {
                view.sizeToFit()
                img1Height.constant = 90
                ghsImg1Gap.constant = 20
                img6Height.constant = 90
                ghsImg6Gap.constant = 78
                
//                if (view.frame.height < 1024) {
                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                    img6.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
//                } else {
//                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
//                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
//                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
//                    img4.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
//                }
            } else if cArray.count == 5 {

                view.sizeToFit()
                
                img1Height.constant = 90
                 ghsImg1Gap.constant = 20
                 img6Height.constant = 90
                 ghsImg6Gap.constant = 78
                //below iphone 11 pro max, width all less than 414
//                if (view.frame.width <= 414) {
 
                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                    img6.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
                    img7.image = UIImage(named: Bundle.main.path(forResource: cArray[4] as? String, ofType: "png")!)
//                    img4.image = nil
//                    img5.image = nil
//
//                } else {

//                    img1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
//                    img2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
//                    img3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
//                    img4.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
//                    img5.image = UIImage(named: Bundle.main.path(forResource: cArray[4] as? String, ofType: "png")!)
//                    img6.image = nil
//                    img7.image = nil
//                }
            }
        } else {
            img1.image = nil
            img2.image = nil
            img3.image = nil
            img4.image = nil
            img5.image = nil
            img6.image = nil
            img7.image = nil
            
            img1Height.constant = 0
            img6Height.constant = 0
            
            ghsImg1Gap.constant = 0
            ghsImg6Gap.constant = 0
        }
        
        
        //set dg img and sub risk img
        var fixStr = ""
        
        if localViewSDSTIADG.road_dgclass.isEmpty == true || localViewSDSTIADG.road_dgclass.contains("None") {
            dgImg.image = nil
            subImg1.image = nil
            subImg2.image = nil
            
            dgImgHeight.constant = 0
            subImg1height.constant = 0
            dgImgTIInfoGap.constant = 0
            
        } else {
            if (localViewSDSTIADG.road_dgclass.contains(".")) {
                fixStr = localViewSDSTIADG.road_dgclass.replacingOccurrences(of: ".", with: "")
            } else {
                fixStr = localViewSDSTIADG.road_dgclass
            }
            
            dgImgHeight.constant = 90
            dgImgTIInfoGap.constant = 30
            self.dgImg.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
        }
        
        var fixSubStr1 = ""
        var fixSubStr2 = ""
        var fixSubArray: Array<String> = []
 
        if (localViewSDSTIADG.road_subrisks.contains("None") || localViewSDSTIADG.road_subrisks.isEmpty == true) {
            self.subImg1.image = nil
            self.subImg2.image = nil
            
            subImg1height.constant = 0
            subImg1_2Gap.constant = 0
            
            
        } else {
             if (localViewSDSTIADG.road_subrisks.isEmpty == false) {
                
                 fixSubArray = localViewSDSTIADG.road_subrisks.components(separatedBy: " ")
        //                         print("Array: \(fixSubArray.count)")
                 if (fixSubArray.count == 2) {
                     
                     fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                     fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                     
                     self.subImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                     self.subImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                 } else if (fixSubArray.count == 1 ) {
                    if fixSubStr1.contains("None") || fixSubStr1.contains("NIL") || fixSubStr1.isEmpty == true {
                        
                        self.subImg1.image = nil
                     } else {
                         
                         fixSubStr1 = fixSubArray[0].replacingOccurrences(of: " ", with: "")
                         self.subImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                     }
                 }
             }
        }

    }
    
    func setTitleBold() {
        GHSClassT.font = UIFont.boldSystemFont(ofSize: 18)
        HazardST.font = UIFont.boldSystemFont(ofSize: 18)
        PercauT.font = UIFont.boldSystemFont(ofSize: 18)
        PST.font = UIFont.boldSystemFont(ofSize: 18)
        TIT.font = UIFont.boldSystemFont(ofSize: 18)
        

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
    

    
    @IBAction func allBtnTapped(_ sender: Any) {
            
        getValue()

    }
        
    @IBAction func ghsBtnTapped(_ sender: Any) {
        
        setghsBtnStyle()
        
        GHSScrollView.isHidden = false
        containerView.isHidden = true
        
        navigationItem.title = "GHS"
        
        self.HazhazGap.constant = 10
        self.hazPreGap.constant = 20
        self.PregenGap.constant = 10
        
        dgImg.image = nil
        subImg1.image = nil
        subImg2.image = nil
        
        if (localViewSDSGHS.formatcode == "0F" || localViewSDSGHS.formatcode == "0A") {
            self.HazardST.text = "HAZARD STATEMENT(S)"
            self.PercauT.text = "PRECAUTIONARY STATEMENT(S)"
            self.haz.text = localViewSDSGHS.hstate
            let psStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
            let breakStr: NSMutableAttributedString = NSMutableAttributedString(string: "\n")
            
            if (localViewSDSGHS.ps_general.isEmpty == false) {
                let str = "General:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSGHS.ps_general)
                
                psStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                psStr.append(strdata)
                psStr.append(breakStr)
            }
            
            if (localViewSDSGHS.ps_prevention.isEmpty == false) {

                
                let str = "\nPrevention:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSGHS.ps_prevention)
                
                
                psStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                psStr.append(strdata)
                psStr.append(breakStr)
            }
            
            if (localViewSDSGHS.ps_response.isEmpty == false) {

                
                let str = "\nResponse:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSGHS.ps_response)
                
                psStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                psStr.append(strdata)
                psStr.append(breakStr)
            }
            
            if (localViewSDSGHS.ps_storage.isEmpty == false) {

                let str = "\nStorage:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSGHS.ps_storage)
                
                
                psStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                psStr.append(strdata)
                psStr.append(breakStr)
            }
            
            if (localViewSDSGHS.ps_disposal.isEmpty == false) {
                
                let str = "\nDisposal:\n"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let strdata = NSMutableAttributedString(string: localViewSDSGHS.ps_disposal)
  
                psStr.append(NSMutableAttributedString(string: str, attributes: attrs))
                psStr.append(strdata)
            }
            
            self.pstate.attributedText = psStr
            
            
         } else {
             self.HazardST.text = "RISK PHRASE(S)"
             self.PercauT.text = "SAFETY PHRASE(S)"
            
            if (localViewSDSCF.rphrase == "") {
                self.haz.text = "None."
            } else {
                self.haz.text = localViewSDSCF.rphrase
            }
            
            if (localViewSDSCF.sphrase == "") {
                self.pstate.text = "None."
            } else {
                self.pstate.text = localViewSDSCF.sphrase
            }
             
         }
        

        self.TIT.text = ""
        self.TIInfo.text = ""
        self.TrandgImgGap.constant = 0
        self.dgImgHeight.constant = 0
        self.subImg1height.constant = 0
        self.TransubImg1Gap.constant = 0
        self.subImg1_2Gap.constant = 0
        self.dgImgTIInfoGap.constant = 0
        
        self.unPSGap.constant = 0
        self.PST.text = ""
        self.PSpsGap.constant = 0
        self.ps.text = ""
        
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
        
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        

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
        
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        

        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSFA") as? SDSViewFA_VC
//         self.navigationController?.pushViewController(sdsJump!, animated: true)
        
        addChild(sdsJump!)
        sdsJump!.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        containerView.addSubview(sdsJump!.view)

        sdsJump!.didMove(toParent: self)
    }
    
}
