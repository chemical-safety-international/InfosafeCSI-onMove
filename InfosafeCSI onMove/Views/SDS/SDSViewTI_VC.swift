//
//  SDSViewTI_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 9/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewTI_VC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var TIT: UILabel!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnView.layer.cornerRadius = 15
        ADGBtn.layer.cornerRadius = 15
        IMDGBtn.layer.cornerRadius = 15
        IATABtn.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
        TIT.font = UIFont.boldSystemFont(ofSize: 25)
        
        UNNOT.font = UIFont.boldSystemFont(ofSize: 16)
        DGCLT.font = UIFont.boldSystemFont(ofSize: 16)
        SUBRT.font = UIFont.boldSystemFont(ofSize: 16)
        PACKT.font = UIFont.boldSystemFont(ofSize: 16)
        PSNT.font = UIFont.boldSystemFont(ofSize: 16)
        SYMBT.font = UIFont.boldSystemFont(ofSize: 16)
        EMST.font = UIFont.boldSystemFont(ofSize: 16)
        MPT.font = UIFont.boldSystemFont(ofSize: 16)
        HCT.font = UIFont.boldSystemFont(ofSize: 16)
        EPGT.font = UIFont.boldSystemFont(ofSize: 16)
        IERGT.font = UIFont.boldSystemFont(ofSize: 16)
        PMT.font = UIFont.boldSystemFont(ofSize: 16)
        
        TIScrollView.delegate = self
        
        TIScrollView.isHidden = true
        btnView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        
        callTI()
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = TIScrollView.contentOffset.y + TIScrollView.frame.size.height
        TIScrollView.sizeToFit()
        DispatchQueue.main.async {
            if (bottomEdge >= self.TIScrollView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            } else if (bottomEdge < self.TIScrollView.contentSize.height - 10)
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
    
    
    func callTI() {
        csiWCF_VM().callSDS_Trans() { (output) in
            if output.contains("true") {

                self.getValue()
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
            
            
            var fixStr = ""
            var fixSubStr1 = ""
            var fixSubStr2 = ""
            var fixSubArray: Array<String> = []
            
            if (localViewSDSTIADG.road_dgclass.isEmpty == false) {
                if (localViewSDSTIADG.road_dgclass.contains(".")) {
                    fixStr = localViewSDSTIADG.road_dgclass.replacingOccurrences(of: ".", with: "")

                } else {
                    
                    fixStr = localViewSDSTIADG.road_dgclass
 
                }
                self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
            }
            
            
            if (localViewSDSTIADG.road_subrisks.isEmpty == false) {
                fixSubArray = localViewSDSTIADG.road_subrisks.components(separatedBy: ",")
                print("Array: \(fixSubArray.count)")
                print(fixSubArray)
                if (fixSubArray.count == 2) {
                    print("here1")
                    fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                    fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                    
                    self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                    self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                } else if (fixSubArray.count == 1 ) {
                    print("here2")
                    fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ",", with: "")
                    print(fixSubStr1)
                    self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                } else {
                    self.subRiskImg1.image = nil
                    self.subRiskImg2.image = nil
                }
            }


            
            self.viewMore()
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
            self.ADGBtn.backgroundColor = UIColor(red:0.28, green:0.34, blue:0.52, alpha:1.0)
            self.IMDGBtn.backgroundColor = UIColor.clear
            self.IATABtn.backgroundColor = UIColor.clear
        }
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
        
        contentView.sizeToFit()
        TIScrollView.sizeToFit()
        
        let cont1 = UNNOT.frame.height + DGCLT.frame.height + SUBRT.frame.height + PACKT.frame.height
        let cont2 = PSNT.frame.height + SYMBT.frame.height + EMST.frame.height + MPT.frame.height
        let cont3 = HCT.frame.height + EPGT.frame.height + IERGT.frame.height + PMT.frame.height
        let cont4 = unno.frame.height + dgClassImage.frame.height + subRiskImg1.frame.height + pg.frame.height
        let cont5 = psn.frame.height + symb.frame.height + ems.frame.height + mp.frame.height
        let cont6 = hc.frame.height + epg.frame.height + ierg.frame.height + pm.frame.height
        
        let conT = cont1 + cont2 + cont3 + cont4 + cont5 + cont6
        
        
//        print("content View \(contentView.frame.height)")
//        print("TIScroll View \(TIScrollView.frame.height)")
//        print("Real View \(conT)")
        
        //check if the real content height is over or less the content view height
        if (contentView.frame.height > TIScrollView.frame.height) {

            if (TIScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
                TIScrollView.isScrollEnabled = true
            } else if (TIScrollView.frame.height - conT <= 50.0) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
                TIScrollView.isScrollEnabled = true
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
                TIScrollView.isScrollEnabled = false
            }
        } else if (contentView.frame.height < TIScrollView.frame.height) {
            if (TIScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
                TIScrollView.isScrollEnabled = true
            } else if (TIScrollView.frame.height - conT <= 50.0) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
                TIScrollView.isScrollEnabled = true
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
                TIScrollView.isScrollEnabled = false
            }
        } else if (contentView.frame.height == TIScrollView.frame.height) {
            if (TIScrollView.frame.height < conT) {
                self.viewMoreLbl.isHidden = false
                self.scrollDownArrow.isHidden = false
                TIScrollView.isScrollEnabled = true
            } else {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
                TIScrollView.isScrollEnabled = false
            }
        }
        
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
            
           var fixStr = ""
           var fixSubStr1 = ""
           var fixSubStr2 = ""
           var fixSubArray: Array<String> = []
           
            if (localViewSDSTIIMDG.imdg_dgclass.isEmpty == false) {
               if (localViewSDSTIIMDG.imdg_dgclass.contains(".")) {
                   fixStr = localViewSDSTIIMDG.imdg_dgclass.replacingOccurrences(of: ".", with: "")

               } else {
                   
                   fixStr = localViewSDSTIIMDG.imdg_dgclass

               }
               self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
           }
           
           
            if (localViewSDSTIIMDG.imdg_subrisks.isEmpty == false) {
                fixSubArray = localViewSDSTIIMDG.imdg_subrisks.components(separatedBy: ",")
                print("Array: \(fixSubArray.count)")
                if (fixSubArray.count == 2) {
                    
                    fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                    fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                    
                    self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                    self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                } else if (fixSubArray.count == 1 ) {
                    fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ",", with: "")
                    self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                }
            }

            
            self.viewMore()
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
            self.ADGBtn.backgroundColor = UIColor.clear
            self.IMDGBtn.backgroundColor = UIColor(red:0.28, green:0.34, blue:0.52, alpha:1.0)
            self.IATABtn.backgroundColor = UIColor.clear
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
            
            var fixStr = ""
            var fixSubStr1 = ""
               var fixSubStr2 = ""
               var fixSubArray: Array<String> = []
               
            if (localViewSDSTIIATA.iata_dgclass.isEmpty == false) {
                   if (localViewSDSTIIATA.iata_dgclass.contains(".")) {
                       fixStr = localViewSDSTIIATA.iata_dgclass.replacingOccurrences(of: ".", with: "")

                   } else {
                       
                       fixStr = localViewSDSTIIATA.iata_dgclass

                   }
                   self.dgClassImage.image = UIImage(named: Bundle.main.path(forResource: fixStr, ofType: "png")!)
               }
               
               
            if (localViewSDSTIIATA.iata_subrisks.isEmpty == false) {
                fixSubArray = localViewSDSTIIATA.iata_subrisks.components(separatedBy: ",")
                  print("Array: \(fixSubArray.count)")
                  if (fixSubArray.count == 2) {
                      
                      fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ".", with: "")
                      fixSubStr2 = fixSubArray[1].replacingOccurrences(of: ".", with: "")
                      
                      self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                      self.subRiskImg2.image = UIImage(named: Bundle.main.path(forResource: fixSubStr2, ofType: "png")!)
                  } else if (fixSubArray.count == 1 ) {
                      fixSubStr1 = fixSubArray[0].replacingOccurrences(of: ",", with: "")
                      self.subRiskImg1.image = UIImage(named: Bundle.main.path(forResource: fixSubStr1, ofType: "png")!)
                  }
            }
  
            
            
            self.viewMore()
            self.TIScrollView.isHidden = false
            self.btnView.isHidden = false
            
            self.ADGBtn.backgroundColor = UIColor.clear
            self.IMDGBtn.backgroundColor = UIColor.clear
            self.IATABtn.backgroundColor = UIColor(red:0.28, green:0.34, blue:0.52, alpha:1.0)
        }
    }
    
}
