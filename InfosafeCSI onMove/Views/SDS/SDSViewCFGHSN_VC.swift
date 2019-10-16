//
//  SDSViewCFGHSN_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 15/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewCFGHSN_VC: UIViewController {
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
            
            
            self.viewMore()
            //set the collection view height same as it expanded
            self.setImage()

            self.GHSScrollView.isHidden = false


        }
    }
    
    //when user scrolling hide the label
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.viewMoreLbl.isHidden = true
//        self.scrollDownArrow.isHidden = true
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = GHSScrollView.contentOffset.y + GHSScrollView.frame.size.height
        GHSScrollView.sizeToFit()
        DispatchQueue.main.async {
            if (bottomEdge >= self.GHSScrollView.contentSize.height - 10) {
                self.viewMoreLbl.isHidden = true
                self.scrollDownArrow.isHidden = true
            } else if (bottomEdge < self.GHSScrollView.contentSize.height - 10)
            {
                self.viewMore()
            }
        }
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
        
        contentView.sizeToFit()
        GHSScrollView.sizeToFit()

        
        let cont1 = GHSClassT.frame.height + HazardST.frame.height + PercauT.frame.height
        let cont2 = PST.frame.height + DanGT.frame.height + ghsclass.frame.height
        let cont3 = haz.frame.height + pstate.frame.height + ps.frame.height
        let cont4 = dang.frame.height + ptg.frame.height + PTGT.frame.height
        let cont5 = img1.frame.height + img6.frame.height/2
        
        let conT = cont1 + cont2 + cont3 + cont4 + cont5 + 80
        
        
        //check if the real content height is over or less the content view height
        if (contentView.frame.height > GHSScrollView.frame.height) {

            self.viewMoreLbl.isHidden = false
            self.scrollDownArrow.isHidden = false
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

}
