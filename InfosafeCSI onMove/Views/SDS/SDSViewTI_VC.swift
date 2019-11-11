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
    
    
    @IBOutlet weak var topdgImgGap: NSLayoutConstraint!
    @IBOutlet weak var dgImgHeight: NSLayoutConstraint!
    @IBOutlet weak var subImgHeight: NSLayoutConstraint!
    @IBOutlet weak var dgImgDGCGap: NSLayoutConstraint!
    

    @IBOutlet weak var psnSYMGap: NSLayoutConstraint!
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

//        csiWCF_VM().callSDS_Trans() { (output) in
//            if output.contains("true") {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                self.getValue()
  
//            }else {
//                print("Something wrong!")
//            }
//        }
    }
    
    func getValue() {
        DispatchQueue.main.async {
            self.unno.text = localViewSDSTIADG.road_unno
            self.pg.text = localViewSDSTIADG.road_packgrp
            self.psn.text = localViewSDSTIADG.road_psn
            
            self.psnSYMGap.constant = 0
            self.SYMBT.text = ""
            self.symb.text = ""
            
            self.symEMSGap.constant = 0
            self.EMST.text = ""
            self.ems.text = ""
            
            self.emsMPGap.constant = 0
            self.MPT.text = ""
            self.mp.text = ""
            
            self.dgClassImage.image = nil
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            
            self.dgCLbl.text = localViewSDSTIADG.road_dgclass
            self.subRiskLbl.text = localViewSDSTIADG.road_subrisks
            
            if (localViewSDSTIADG.road_hazchem.isEmpty == false) {
                self.HCT.text = "HAZCHEM CODE"
                self.hc.text = localViewSDSTIADG.road_hazchem
                self.mpHCGap.constant = 10
            } else {
                self.HCT.text = ""
                self.hc.text = ""
                self.mpHCGap.constant = 0
            }
            
            
            if (localViewSDSTIADG.road_epg.isEmpty == false) {
                self.EPGT.text = "EPG NUMBER"
                self.epg.text = localViewSDSTIADG.road_epg
                self.hcEPGGap.constant = 10
            } else {
                self.EPGT.text = ""
                self.epg.text = ""
                self.hcEPGGap.constant = 0
            }
            
            if (localViewSDSTIADG.road_ierg.isEmpty == false) {
                self.IERGT.text = "IERG NUMBER"
                self.ierg.text = localViewSDSTIADG.road_ierg
                self.epgIERGap.constant = 10
            } else {
                self.IERGT.text = ""
                self.ierg.text = ""
                self.epgIERGap.constant = 0
            }
            
            
            if (localViewSDSTIADG.road_packmethod.isEmpty == false) {
                self.PMT.text = "PACKAGING METHOD"
                self.pm.text = localViewSDSTIADG.road_packmethod
                self.ierPMGap.constant = 10
            } else {
                self.PMT.text = ""
                self.pm.text = ""
                self.ierPMGap.constant = 0
            }
            
            self.setImg()


//            self.TIScrollView.sizeToFit()
//            let bottomEdge = self.TIScrollView.contentOffset.y + self.TIScrollView.frame.size.height
//
//            DispatchQueue.main.async {
//                if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
//                    self.viewMoreLbl.isHidden = true
//                    self.scrollDownArrow.isHidden = true
//                } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
//                {
//                    self.viewMore()
//                }
//            }
            self.viewMore()
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
    
    func setImg() {
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
                topdgImgGap.constant = 35
                dgImgDGCGap.constant = 45
                self.dgImgHeight.constant = 150
                self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
                self.dgCLbl.text = localViewSDSTIADG.road_dgclass
            }


        } else {
            
            self.dgCLbl.text = ""
            self.dgClassImage.image = nil
            topdgImgGap.constant = 0
            dgImgHeight.constant = 0
            subImgHeight.constant = 0
            dgImgDGCGap.constant = 0
        }
        
        
        if (localViewSDSTIADG.road_subrisks != "") {
            
            if localViewSDSTIADG.road_subrisks.contains("None") {
                self.subRiskLbl.text = localViewSDSTIADG.road_subrisks
            } else {
                self.subImgHeight.constant = 110
                fixSubArray = localViewSDSTIADG.road_subrisks.components(separatedBy: " ")

                if (fixSubArray.count == 2) {

                    fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                    fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                    
                    self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                    self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                } else if (fixSubArray.count == 1 ) {

                    fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                    self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)

                } else {
                    self.subRiskImg1.image = nil
                    self.subRiskImg2.image = nil
                    self.subImgHeight.constant = 0
                }
            }

        } else {
            self.subRiskLbl.text = ""
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            self.subImgHeight.constant = 0
        }
    }
    
    func viewMore() {
        
        DispatchQueue.main.async {
            self.UNNOT.sizeToFit()
             self.DGCLT.sizeToFit()
             self.SUBRT.sizeToFit()
             self.PACKT.sizeToFit()
             self.PSNT.sizeToFit()
             self.SYMBT.sizeToFit()
             self.EMST.sizeToFit()
             self.MPT.sizeToFit()
             self.HCT.sizeToFit()
             self.EPGT.sizeToFit()
             self.IERGT.sizeToFit()
             self.PMT.sizeToFit()
             
             self.unno.sizeToFit()
             self.dgClassImage.sizeToFit()
             self.subRiskImg1.sizeToFit()
             self.pg.sizeToFit()
             self.psn.sizeToFit()
             self.symb.sizeToFit()
             self.ems.sizeToFit()
             self.mp.sizeToFit()
             self.hc.sizeToFit()
             self.epg.sizeToFit()
             self.ierg.sizeToFit()
             self.pm.sizeToFit()
             
             
             self.dgCLbl.sizeToFit()
             self.subRiskLbl.sizeToFit()
             
             self.contentView.sizeToFit()
             self.TIScrollView.sizeToFit()
             
            let cont1 = self.DGCLT.frame.height + self.topdgImgGap.constant + self.dgImgHeight.constant + self.dgImgDGCGap.constant
            let cont2 = self.PSNT.frame.height + self.SYMBT.frame.height + self.EMST.frame.height + self.MPT.frame.height
            let cont3 = self.HCT.frame.height + self.EPGT.frame.height + self.IERGT.frame.height + self.PMT.frame.height
            let cont4 = self.unno.frame.height + 20
            let cont5 = self.psn.frame.height + self.symb.frame.height + self.ems.frame.height + self.mp.frame.height
            let cont6 = self.hc.frame.height + self.epg.frame.height + self.ierg.frame.height + self.pm.frame.height
            let cont7 = self.psnSYMGap.constant + self.symEMSGap.constant
            let cont8 = self.emsMPGap.constant + self.mpHCGap.constant + self.hcEPGGap.constant + self.epgIERGap.constant + self.ierPMGap.constant
             
             
             
             let conT = cont1 + cont2 + cont3 + cont4 + cont5 + cont6 + cont7 + cont8 + 10
             
             if conT > self.TIScrollView.frame.height {
                 self.viewMoreLbl.isHidden = false
                 self.scrollDownArrow.isHidden = false
             } else {
                 self.viewMoreLbl.isHidden = true
                 self.scrollDownArrow.isHidden = true
             }
        }
 
        
    }
    @IBAction func adgBtnTapped(_ sender: Any) {
        
        getValue()

        
    }
    @IBAction func imdgBtnTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.unno.text = localViewSDSTIIMDG.imdg_unno
            self.dgCLbl.text = localViewSDSTIIMDG.imdg_dgclass
            self.subRiskLbl.text = localViewSDSTIIMDG.imdg_subrisks
            self.pg.text = localViewSDSTIIMDG.imdg_packgrp
            self.psn.text = localViewSDSTIIMDG.imdg_psn
            
            self.dgClassImage.image = nil
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            
            self.dgCLbl.text = localViewSDSTIIMDG.imdg_dgclass
            self.subRiskLbl.text = localViewSDSTIIMDG.imdg_subrisks
            
            self.psnSYMGap.constant = 0
            self.SYMBT.text = ""
            self.symb.text = ""
            
            
            if(localViewSDSTIIMDG.imdg_ems.isEmpty == false) {
                self.EMST.text = "EMS"
                self.ems.text = localViewSDSTIIMDG.imdg_ems
                self.symEMSGap.constant = 10
            } else {
                self.EMST.text = ""
                self.ems.text = ""
                self.symEMSGap.constant = 0
            }
            
            if(localViewSDSTIIMDG.imdg_mp.isEmpty == false) {
                self.MPT.text = "MARINE POLLUTANT"
                self.mp.text = localViewSDSTIIMDG.imdg_mp
                self.emsMPGap.constant = 10
            } else {
                self.MPT.text = ""
                self.mp.text = ""
                self.emsMPGap.constant = 0
            }
            
            self.mpHCGap.constant = 0
            self.HCT.text = ""
            self.hc.text = ""
            
            self.hcEPGGap.constant = 0
            self.EPGT.text = ""
            self.epg.text = ""
            
            self.epgIERGap.constant = 0
            self.IERGT.text = ""
            self.ierg.text = ""
            
            self.ierPMGap.constant = 0
            self.PMT.text = ""
            self.pm.text = ""
 
            
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
                    self.topdgImgGap.constant = 35
                    self.dgImgDGCGap.constant = 45
                    self.dgImgHeight.constant = 150
                    self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
                    self.dgCLbl.text = localViewSDSTIIMDG.imdg_dgclass
                    
                 } else {
                    self.dgCLbl.text = ""
                    self.dgClassImage.image = nil
                    self.topdgImgGap.constant = 0
                    self.dgImgHeight.constant = 0
                    self.subImgHeight.constant = 0
                    self.dgImgDGCGap.constant = 0
                }
                
                if localViewSDSTIIMDG.imdg_subrisks.contains("None") {
                    self.subRiskLbl.text = localViewSDSTIIMDG.imdg_subrisks
                } else {
                     if (localViewSDSTIIMDG.imdg_subrisks.isEmpty == false) {
                        self.subImgHeight.constant = 110
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
                        self.subRiskImg1.image = nil
                        self.subRiskImg2.image = nil
                        self.subImgHeight.constant = 0
 
                    }
                }


            }

//            self.TIScrollView.sizeToFit()
//            let bottomEdge = self.TIScrollView.contentOffset.y + self.TIScrollView.frame.size.height
//
//            DispatchQueue.main.async {
//                if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
//                    self.viewMoreLbl.isHidden = true
//                    self.scrollDownArrow.isHidden = true
//                } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
//                {
//                    self.viewMore()
//                }
//            }
            self.viewMore()
            
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
            
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
            self.dgCLbl.text = localViewSDSTIIATA.iata_dgclass
            self.subRiskLbl.text = localViewSDSTIIATA.iata_subrisks
            self.pg.text = localViewSDSTIIATA.iata_packgrp
            self.psn.text = localViewSDSTIIATA.iata_psn
        
            self.dgClassImage.image = nil
            self.subRiskImg1.image = nil
            self.subRiskImg2.image = nil
            
            self.dgCLbl.text = localViewSDSTIIATA.iata_dgclass
            self.subRiskLbl.text = localViewSDSTIIATA.iata_subrisks
            
            if(localViewSDSTIIATA.iata_symbol.isEmpty == false) {
                self.SYMBT.text = "SYMBOL"
                self.symb.text = localViewSDSTIIATA.iata_symbol
                self.psnSYMGap.constant = 10
            } else {
                self.SYMBT.text = ""
                self.symb.text = ""
                self.psnSYMGap.constant = 0
            }
            
            self.symEMSGap.constant = 0
            self.EMST.text = ""
            self.ems.text = ""
            
            self.emsMPGap.constant = 0
            self.MPT.text = ""
            self.mp.text = ""
            
            self.mpHCGap.constant = 0
            self.HCT.text = ""
            self.hc.text = ""
            
            self.hcEPGGap.constant = 0
            self.EPGT.text = ""
            self.epg.text = ""
            
            self.epgIERGap.constant = 0
            self.IERGT.text = ""
            self.ierg.text = ""
            
            self.ierPMGap.constant = 0
            self.PMT.text = ""
            self.pm.text = ""
            
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
                  self.topdgImgGap.constant = 35
                  self.dgImgDGCGap.constant = 45
                  self.dgImgHeight.constant = 150
                  self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
                    self.dgCLbl.text = localViewSDSTIIATA.iata_dgclass
                } else {
                    self.dgCLbl.text = ""
                    self.dgClassImage.image = nil
                    self.topdgImgGap.constant = 0
                    self.dgImgHeight.constant = 0
                    self.subImgHeight.constant = 0
                    self.dgImgDGCGap.constant = 0
                }
            }

               
            if localViewSDSTIIATA.iata_subrisks.contains("None") {
                self.subRiskLbl.text = localViewSDSTIIATA.iata_subrisks
            } else {
                if (localViewSDSTIIATA.iata_subrisks.isEmpty == false) {
                    self.subImgHeight.constant = 110
                    fixSubArray = localViewSDSTIIATA.iata_subrisks.components(separatedBy: " ")

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
                    self.subRiskImg1.image = nil
                    self.subRiskImg2.image = nil
                    self.subImgHeight.constant = 0

                }
            }

  
            
//            self.TIScrollView.sizeToFit()
//            let bottomEdge = self.TIScrollView.contentOffset.y + self.TIScrollView.frame.size.height
//
//            DispatchQueue.main.async {
//                if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
//                    self.viewMoreLbl.isHidden = true
//                    self.scrollDownArrow.isHidden = true
//                } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
//                {
//                    self.viewMore()
//                }
//            }
            self.viewMore()
            
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
