//
//  SDSViewTI_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewTI_VC: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var UNNOT: UILabel!
    @IBOutlet weak var DGCLT: UILabel!
    @IBOutlet weak var SUBRT: UILabel!
    @IBOutlet weak var PACKT: UILabel!
    @IBOutlet weak var PSNT: UILabel!
    @IBOutlet weak var SYMBT: UILabel!
    @IBOutlet weak var EMST: UILabel!
    @IBOutlet weak var MPT: UILabel!
    @IBOutlet weak var HCT: UILabel!
    @IBOutlet weak var EPGT: UILabel!
    @IBOutlet weak var IERGT: UILabel!
    @IBOutlet weak var PMT: UILabel!
    
    @IBOutlet weak var unno: UILabel!
    @IBOutlet weak var pg: UILabel!
    @IBOutlet weak var psn: UILabel!
    @IBOutlet weak var symb: UILabel!
    @IBOutlet weak var ems: UILabel!
    @IBOutlet weak var mp: UILabel!
    @IBOutlet weak var hc: UILabel!
    @IBOutlet weak var epg: UILabel!
    @IBOutlet weak var ierg: UILabel!
    @IBOutlet weak var pm: UILabel!
    
    @IBOutlet weak var TIScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var viewMoreLbl: UILabel!
    @IBOutlet weak var scrollDownArrow: UIImageView!
    
    @IBOutlet weak var btnView: UIView!
    
    @IBOutlet weak var IMDGBtn: UIButton!
    @IBOutlet weak var IATABtn: UIButton!
    @IBOutlet weak var ADGBtn: UIButton!
    
    
    @IBOutlet weak var dgClassImage: UIImageView!
    @IBOutlet weak var subRiskImg1: UIImageView!
    @IBOutlet weak var subRiskImg2: UIImageView!
    
    @IBOutlet weak var dgCLbl: UILabel!
    @IBOutlet weak var subRiskLbl: UILabel!
    
    
    
    

    @IBOutlet weak var symEMSGap: NSLayoutConstraint!
    @IBOutlet weak var emsMPGap: NSLayoutConstraint!
    @IBOutlet weak var mpHCGap: NSLayoutConstraint!
    @IBOutlet weak var hcEPGGap: NSLayoutConstraint!
    @IBOutlet weak var epgIERGap: NSLayoutConstraint!
    @IBOutlet weak var ierPMGap: NSLayoutConstraint!
    
    
    @IBOutlet weak var bcImg: UIImageView!
    
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnView.layer.cornerRadius = 15
        ADGBtn.layer.cornerRadius = 15
        IMDGBtn.layer.cornerRadius = 15
        IATABtn.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
        
        UNNOT.font = UIFont.boldSystemFont(ofSize: 20)
        DGCLT.font = UIFont.boldSystemFont(ofSize: 20)
        SUBRT.font = UIFont.boldSystemFont(ofSize: 20)
        PACKT.font = UIFont.boldSystemFont(ofSize: 20)
        PSNT.font = UIFont.boldSystemFont(ofSize: 20)
        SYMBT.font = UIFont.boldSystemFont(ofSize: 20)
        EMST.font = UIFont.boldSystemFont(ofSize: 20)
        MPT.font = UIFont.boldSystemFont(ofSize: 20)
        HCT.font = UIFont.boldSystemFont(ofSize: 20)
        EPGT.font = UIFont.boldSystemFont(ofSize: 20)
        IERGT.font = UIFont.boldSystemFont(ofSize: 20)
        PMT.font = UIFont.boldSystemFont(ofSize: 20)
        
        TIScrollView.delegate = self
        
        TIScrollView.isHidden = true
        btnView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        
        ADGBtn.layer.cornerRadius = 15
        IMDGBtn.layer.cornerRadius = 15
        IATABtn.layer.cornerRadius = 15
        
        callTI()
    }
    

    //control the scroll bar and image
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        TIScrollView.sizeToFit()
        let bottomEdge = TIScrollView.contentOffset.y + TIScrollView.frame.size.height

        DispatchQueue.main.async {
            if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true

            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("last: \(lastContentOffset)")
//        print(scrollView.contentOffset.y)
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            print("going up")
           let bottomEdge = TIScrollView.contentOffset.y + TIScrollView.frame.size.height
            DispatchQueue.main.async {
                if (bottomEdge <= self.TIScrollView.contentSize.height - 10)
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
    
    
    func callTI() {

        csiWCF_VM().callSDS_Trans() { (output) in
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
            self.unno.text = localViewSDSTIADG.road_unno
            self.pg.text = localViewSDSTIADG.road_packgrp
            self.psn.text = localViewSDSTIADG.road_psn
            self.symb.text = ""
            self.ems.text = ""
            self.mp.text = ""
            self.hc.text = localViewSDSTIADG.road_hazchem
            self.epg.text = localViewSDSTIADG.road_epg
            self.ierg.text = localViewSDSTIADG.road_ierg
            self.pm.text = localViewSDSTIADG.road_packmethod
            
            self.dgClassImage.image = nil
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            
            self.dgCLbl.text = localViewSDSTIADG.road_dgclass
            self.subRiskLbl.text = ""
            
            self.SYMBT.text = ""
            self.EMST.text = ""
            self.MPT.text = ""
            
            self.HCT.text = "HAZCHEM CODE"
            self.EPGT.text = "EPG NUMBER"
            self.IERGT.text = "IERG NUMBER"
            self.PMT.text = "PACKAGING METHOD"
            
//            self.dgImgHeight.constant = 0
//            self.subImgHeight.constant = 0
//            self.psnSymGap.constant = 0
//            self.symEMSGap.constant = 0
//            self.emsMPGap.constant = 0
//            self.mpHCGap.constant = 10
//            self.hcEPGGap.constant = 10
//            self.epgIERGap.constant = 10
//            self.ierPMGap.constant = 10
            
//            print(self.subImgHeight.constant)
            var fixStr = ""
            var fixSubStr1 = ""
            var fixSubStr2 = ""
            var fixSubArray: Array<String> = []
            
            if (localViewSDSTIADG.road_dgclass != "") {
                if (localViewSDSTIADG.road_dgclass.contains("None")) {
                    self.dgCLbl.text = localViewSDSTIADG.road_dgclass
                } else {
                   if (localViewSDSTIADG.road_dgclass.contains(".")) {
                       fixStr = localViewSDSTIADG.road_dgclass.replacingOccurrences(of: ".", with: "")

                   } else {
                       
                       fixStr = localViewSDSTIADG.road_dgclass
    
                   }
//                    self.dgImgHeight.constant = 90

                   self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
                }


            } else {
                self.dgCLbl.text = ""
            }
            
            
            if (localViewSDSTIADG.road_subrisks != "") {
                
                if localViewSDSTIADG.road_subrisks.contains("None") {
                    self.subRiskLbl.text = localViewSDSTIADG.road_subrisks
                } else {
//                    self.subImgHeight.constant = 90
                    fixSubArray = localViewSDSTIADG.road_subrisks.components(separatedBy: " ")
    //                print("Array: \(fixSubArray.count)")
//                    print(fixSubArray)
                    if (fixSubArray.count == 2) {
    //                    print("here1")
                        fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                        fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                        
                        self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                        self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                    } else if (fixSubArray.count == 1 ) {
    //                    print("here2")
                        fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                        self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)

                    } else {
                        self.subRiskImg1.image = nil
                        self.subRiskImg2.image = nil
                    }
                }

            } else {
                self.subRiskLbl.text = ""
//                self.subImgHeight.constant = 0
            }


            self.TIScrollView.sizeToFit()
            let bottomEdge = self.TIScrollView.contentOffset.y + self.TIScrollView.frame.size.height

            DispatchQueue.main.async {
                if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
                    self.viewMoreLbl.isHidden = true
                    self.scrollDownArrow.isHidden = true
                } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
                {
                    self.viewMore()
                }
            }
//            self.viewMore()
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
//            self.ADGBtn.setTitleColor(UIColor(red:0.94, green:0.45, blue:0.23, alpha:1.0), for: .normal)

            
            
            self.ADGBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            
//            self.IMDGBtn.setTitleColor(UIColor.white, for: .normal)
            self.IMDGBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
//            self.IATABtn.setTitleColor(UIColor.white, for: .normal)
            self.IATABtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
//            self.ADGBtn.backgroundColor = UIColor(red:0.94, green:0.45, blue:0.23, alpha:1.0)
//            self.IMDGBtn.backgroundColor = UIColor.clear
//            self.IATABtn.backgroundColor = UIColor.clear
            
            self.setRoadBtnColor()
            
            self.setRoadBackground()
            
            if (localViewSDSTIIMDG.imdg_unno.isEmpty == true) {
                self.IMDGBtn.isHidden = true
            }
            if (localViewSDSTIIATA.iata_unno.isEmpty == true) {
                self.IATABtn.isHidden = true
            }
        }
        
//        print(subImgHeight.constant)
    }
    
    func viewMore() {
        UNNOT.sizeToFit()
        DGCLT.sizeToFit()
        SUBRT.sizeToFit()
        PACKT.sizeToFit()
        PSNT.sizeToFit()
        SYMBT.sizeToFit()
        EMST.sizeToFit()
        MPT.sizeToFit()
        HCT.sizeToFit()
        EPGT.sizeToFit()
        IERGT.sizeToFit()
        PMT.sizeToFit()
        
        unno.sizeToFit()
        dgClassImage.sizeToFit()
        subRiskImg1.sizeToFit()
        pg.sizeToFit()
        psn.sizeToFit()
        symb.sizeToFit()
        ems.sizeToFit()
        mp.sizeToFit()
        hc.sizeToFit()
        epg.sizeToFit()
        ierg.sizeToFit()
        pm.sizeToFit()
        
        
        dgCLbl.sizeToFit()
        subRiskLbl.sizeToFit()
        
        contentView.sizeToFit()
        TIScrollView.sizeToFit()
        
//        let cont1 = UNNOT.frame.height + DGCLT.frame.height + SUBRT.frame.height + PACKT.frame.height
//        let cont2 = PSNT.frame.height + SYMBT.frame.height + EMST.frame.height + MPT.frame.height
//        let cont3 = HCT.frame.height + EPGT.frame.height + IERGT.frame.height + PMT.frame.height
//        let cont4 = unno.frame.height + pg.frame.height
//        let cont5 = psn.frame.height + symb.frame.height + ems.frame.height + mp.frame.height
//        let cont6 = hc.frame.height + epg.frame.height + ierg.frame.height + pm.frame.height
//        let cont7 = dgCLbl.frame.height + subRiskLbl.frame.height
//        let cont8 = emsMPGap.constant + mpHCGap.constant + hcEPGGap.constant + epgIERGap.constant + ierPMGap.constant
//        
//        
//        
//        let conT = cont1 + cont2 + cont3 + cont4 + cont5 + cont6 + cont7 + cont8 + 60
//        
//        
////        print("content View \(contentView.frame.height)")
////        print("TIScroll View \(TIScrollView.frame.height)")
////        print("Real View \(conT)")
//        
//        //check if the real content height is over or less the content view height
//        if (contentView.frame.height > TIScrollView.frame.height) {
//
//            if (TIScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//                TIScrollView.isScrollEnabled = true
//            } else if (TIScrollView.frame.height - conT <= 100.0) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//                TIScrollView.isScrollEnabled = true
//            } else {
//
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//                TIScrollView.isScrollEnabled = false
//            }
//        } else if (contentView.frame.height < TIScrollView.frame.height) {
//            if (TIScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//                TIScrollView.isScrollEnabled = true
//            } else if (TIScrollView.frame.height - conT <= 50.0) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//                TIScrollView.isScrollEnabled = true
//            } else {
//
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//                TIScrollView.isScrollEnabled = false
//            }
//        } else if (contentView.frame.height == TIScrollView.frame.height) {
//            if (TIScrollView.frame.height < conT) {
//                self.viewMoreLbl.isHidden = false
//                self.scrollDownArrow.isHidden = false
//                TIScrollView.isScrollEnabled = true
//            } else {
//
//                self.viewMoreLbl.isHidden = true
//                self.scrollDownArrow.isHidden = true
//                TIScrollView.isScrollEnabled = false
//            }
//        }
        
    }
    @IBAction func adgBtnTapped(_ sender: Any) {
        
        getValue()

        
    }
    @IBAction func imdgBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.unno.text = localViewSDSTIIMDG.imdg_unno
//            self.dg.text = localViewSDSTIIMDG.imdg_dgclass
//            self.subr.text = localViewSDSTIIMDG.imdg_subrisks
            self.pg.text = localViewSDSTIIMDG.imdg_packgrp
            self.psn.text = localViewSDSTIIMDG.imdg_psn
            self.symb.text = ""
            self.ems.text = localViewSDSTIIMDG.imdg_ems
            self.mp.text = localViewSDSTIIMDG.imdg_mp
            self.hc.text = ""
            self.epg.text = ""
            self.ierg.text = ""
            self.pm.text = ""
            
            self.dgClassImage.image = nil
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            
            self.dgCLbl.text = localViewSDSTIIMDG.imdg_dgclass
            self.subRiskLbl.text = localViewSDSTIIMDG.imdg_subrisks
            
            self.SYMBT.text = ""
            self.HCT.text = ""
            self.EPGT.text = ""
            self.IERGT.text = ""
            self.PMT.text = ""
            
            self.MPT.text = "MARINE POLLUTANT"
            self.EMST.text = "EMS"
            

            
           var fixStr = ""
           var fixSubStr1 = ""
           var fixSubStr2 = ""
           var fixSubArray: Array<String> = []
           
            if localViewSDSTIIMDG.imdg_dgclass.contains("None") {
                self.dgCLbl.text = localViewSDSTIIMDG.imdg_dgclass
            } else {
                 if (localViewSDSTIIMDG.imdg_dgclass.isEmpty == false) {
                    if (localViewSDSTIIMDG.imdg_dgclass.contains(".")) {
                        fixStr = localViewSDSTIIMDG.imdg_dgclass.replacingOccurrences(of: ".", with: "")

                    } else {
                        
                        fixStr = localViewSDSTIIMDG.imdg_dgclass

                    }
 
                    self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
                 } else {
                    self.dgCLbl.text = ""
                }
                
                if localViewSDSTIIMDG.imdg_subrisks.contains("None") {
                    self.subRiskLbl.text = localViewSDSTIIMDG.imdg_subrisks
                } else {
                     if (localViewSDSTIIMDG.imdg_subrisks.isEmpty == false) {

                         fixSubArray = localViewSDSTIIMDG.imdg_subrisks.components(separatedBy: " ")
//                         print("Array: \(fixSubArray.count)")
                         if (fixSubArray.count == 2) {
                             
                             fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                             fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                             
                             self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                             self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                         } else if (fixSubArray.count == 1 ) {
                             if fixSubStr1.contains("None") {
                                 self.subRiskLbl.text = fixSubStr1
                             } else {
                                 
                                 fixSubStr1 = fixSubArray[0].replacingOccurrences(of: " ", with: "")
                                 self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                             }
                         }
                     } else {
                        self.subRiskLbl.text = ""
 
                    }
                }


            }

            self.TIScrollView.sizeToFit()
            let bottomEdge = self.TIScrollView.contentOffset.y + self.TIScrollView.frame.size.height

            DispatchQueue.main.async {
                if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
                    self.viewMoreLbl.isHidden = true
                    self.scrollDownArrow.isHidden = true
                } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
                {
                    self.viewMore()
                }
            }
//            self.viewMore()
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
//            self.ADGBtn.backgroundColor = UIColor.clear
//            self.IMDGBtn.backgroundColor = UIColor(red:0.94, green:0.45, blue:0.23, alpha:1.0)
//            self.IATABtn.backgroundColor = UIColor.clear
            
//            self.ADGBtn.setTitleColor(UIColor.white, for: .normal)
            self.ADGBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
//            self.IMDGBtn.setTitleColor(UIColor(red:0.94, green:0.45, blue:0.23, alpha:1.0), for: .normal)
            self.IMDGBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            
//            self.IATABtn.setTitleColor(UIColor.white, for: .normal)
            self.IATABtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            

            
            self.setSeaBtnColor()
            
            self.setSeaBackground()
           
        }
    }
    @IBAction func iataBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.unno.text = localViewSDSTIIATA.iata_unno
//            self.dg.text = localViewSDSTIIATA.iata_dgclass
//            self.subr.text = localViewSDSTIIATA.iata_subrisks
            self.pg.text = localViewSDSTIIATA.iata_packgrp
            self.psn.text = localViewSDSTIIATA.iata_psn
            self.symb.text = localViewSDSTIIATA.iata_symbol
            self.ems.text = ""
            self.mp.text = ""
            self.hc.text = ""
            self.epg.text = ""
            self.ierg.text = ""
            self.pm.text = ""
            
            self.dgClassImage.image = nil
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            
            self.dgCLbl.text = localViewSDSTIIATA.iata_dgclass
            self.subRiskLbl.text = localViewSDSTIIATA.iata_subrisks
            
            self.EMST.text = ""
            self.MPT.text = ""
            self.HCT.text = ""
            self.EPGT.text = ""
            self.IERGT.text = ""
            self.PMT.text = ""
            
            self.SYMBT.text = "SYMBOL"
            
            
            var fixStr = ""
            var fixSubStr1 = ""
               var fixSubStr2 = ""
               var fixSubArray: Array<String> = []
            if localViewSDSTIIATA.iata_dgclass.contains("None") {
                self.dgCLbl.text = localViewSDSTIIATA.iata_dgclass
            } else {
                if (localViewSDSTIIATA.iata_dgclass.isEmpty == false) {
                       if (localViewSDSTIIATA.iata_dgclass.contains(".")) {
                           fixStr = localViewSDSTIIATA.iata_dgclass.replacingOccurrences(of: ".", with: "")

                       } else {
                           
                           fixStr = localViewSDSTIIATA.iata_dgclass

                       }
  
                       self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
                } else {
                    self.dgCLbl.text = ""
                }
            }

               
            if localViewSDSTIIATA.iata_subrisks.contains("None") {
                self.subRiskLbl.text = localViewSDSTIIATA.iata_subrisks
            } else {
                if (localViewSDSTIIATA.iata_subrisks.isEmpty == false) {

                    fixSubArray = localViewSDSTIIATA.iata_subrisks.components(separatedBy: " ")
//                      print("Array: \(fixSubArray.count)")
                      if (fixSubArray.count == 2) {
                          
                          fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                          fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                          
                          self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                          self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                      } else if (fixSubArray.count == 1 ) {
                        
                        if fixSubStr1.contains("None") {
                            self.subRiskLbl.text = fixSubStr1
                        } else {

                            fixSubStr1 = fixSubArray[0].replacingOccurrences(of: " ", with: "")
                            self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                        }
                      }
                } else {
                    self.subRiskLbl.text = ""

                }
            }

  
            
            self.TIScrollView.sizeToFit()
            let bottomEdge = self.TIScrollView.contentOffset.y + self.TIScrollView.frame.size.height

            DispatchQueue.main.async {
                if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
                    self.viewMoreLbl.isHidden = true
                    self.scrollDownArrow.isHidden = true
                } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
                {
                    self.viewMore()
                }
            }
//            self.viewMore()
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
            
//            self.ADGBtn.setTitleColor(UIColor.white, for: .normal)
            self.ADGBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
//            self.IMDGBtn.setTitleColor(UIColor.white, for: .normal)
            self.IMDGBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
//            self.IATABtn.setTitleColor(UIColor(red:0.94, green:0.45, blue:0.23, alpha:1.0), for: .normal)
            self.IATABtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            
            
            
            self.setAirBtnColor()
            
            self.setAirBackground()
        }
    }
    
    func setRoadBackground() {
        bcImg.image = UIImage(named: "CSI-Road")
    }
    
    func setSeaBackground() {
        bcImg.image = UIImage(named: "CSI-Sea")
    }
    
    func setAirBackground() {
        bcImg.image = UIImage(named: "CSI-Air")
    }
    
    func setRoadBtnColor() {
        ADGBtn.backgroundColor = UIColor.orange
        IMDGBtn.backgroundColor = UIColor.darkGray
        IATABtn.backgroundColor = UIColor.darkGray
    }
    
    func setSeaBtnColor() {
        ADGBtn.backgroundColor = UIColor.darkGray
        IMDGBtn.backgroundColor = UIColor.orange
        IATABtn.backgroundColor = UIColor.darkGray
    }
    
    func setAirBtnColor() {
        ADGBtn.backgroundColor = UIColor.darkGray
        IMDGBtn.backgroundColor = UIColor.darkGray
        IATABtn.backgroundColor = UIColor.orange
    }
    
}
