//
//  SDSViewCFGHS_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 7/10/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SDSViewCFGHS_VC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var ClassF: UILabel!
    
    @IBOutlet weak var GHSClassT: UILabel!
    @IBOutlet weak var HazardST: UILabel!
    @IBOutlet weak var PercauT: UILabel!
    @IBOutlet weak var PST: UILabel!
    @IBOutlet weak var DanGT: UILabel!
    
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
    
    @IBOutlet weak var GHSCollectionView: UICollectionView!
    
    let testLabel = ["1","2","3"]
    var buttonImage = ["CSI-ViewSDS", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set the bold text for title texts
        ClassF.font = UIFont.boldSystemFont(ofSize: 25)
        GHSClassT.font = UIFont.boldSystemFont(ofSize: 16)
        HazardST.font = UIFont.boldSystemFont(ofSize: 16)
        PercauT.font = UIFont.boldSystemFont(ofSize: 16)
        PST.font = UIFont.boldSystemFont(ofSize: 16)
        DanGT.font = UIFont.boldSystemFont(ofSize: 16)
        
        GHSScrollView.delegate = self
        
        GHSCollectionView.delegate = self
        
        GHSScrollView.isHidden = true
        viewMoreLbl.isHidden = true
        scrollDownArrow.isHidden = true
        
        callSDSGHS()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func callSDSGHS() {
//        csiWCF_VM().callSDS_GHS() { (output) in
//            if output.contains("true") {
//                print("Successfullt called Class!")
//                self.getValue()
//            } else {
//                print("Something missing!")
//            }
//        }
        
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
            self.GHSScrollView.isHidden = false

            self.GHSCollectionView.reloadData()
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
            self.viewMore()
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
        GHSCollectionView.sizeToFit()
        
        let cont1 = GHSClassT.frame.height + HazardST.frame.height + PercauT.frame.height
        let cont2 = PST.frame.height + DanGT.frame.height + ghsclass.frame.height
        let cont3 = haz.frame.height + pstate.frame.height + ps.frame.height
        let cont4 = dang.frame.height + ptg.frame.height + GHSCollectionView.frame.height
        
        let conT = cont1 + cont2 + cont3 + cont4
        
        
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
}

extension SDSViewCFGHS_VC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localViewSDSGHS.picArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = GHSCollectionView.dequeueReusableCell(withReuseIdentifier: "GHSCell", for: indexPath) as? GHSCollectionViewCell
 
        
        if localViewSDSGHS.picArray.count > 0 {
            
            let imgName = localViewSDSGHS.picArray![indexPath.row]
            let imgNameFix = (imgName as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (imgNameFix == "Flame") {
                let imgCode = "GHS02"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
                
            } else if (imgNameFix == "Skull and crossbones") {
                let imgCode = "GHS06"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Flame over circle") {
                let imgCode = "GHS03"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Exclamation mark") {
                let imgCode = "GHS07"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Environment") {
                let imgCode = "GHS09"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Health hazard") {
                let imgCode = "GHS08"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Corrosion") {
                let imgCode = "GHS05"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Gas cylinder") {
                let imgCode = "GHS04"
                cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            } else if (imgNameFix == "Exploding bomb") {
                let imgCode = "GHS01"
               cell?.gramImage.image = UIImage(named: Bundle.main.path(forResource: imgCode, ofType: "png")!)
            }
        }
        
        return cell!
        
    }
    
    
}
