//
//  TablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

import PDFKit

class SearchTablePage_VC: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var tableDisplay: UITableView!

    @IBOutlet weak var primaryLbl: UILabel!
    @IBOutlet weak var localLbl: UILabel!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var pageNoLbl: UILabel!
    
    @IBOutlet weak var menu: UIView!
    
    @IBOutlet weak var loadmoreLbl: UILabel!
    
    @IBOutlet weak var splitView: UIView!

//    @IBOutlet weak var tablecellView: UIView!
    
    
    var selectedIndex:Bool = false;

    var selectedthecellno = 0
    var testrow = 0
    
    @IBOutlet weak var tabTrailing: NSLayoutConstraint!
    //    @IBOutlet weak var tabTrailing: NSLayoutConstraint!
//    @IBOutlet weak var splitLeading: NSLayoutConstraint!
    @IBOutlet weak var splLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableDisplay.contentInsetAdjustmentBehavior = .never

        self.view.backgroundColor = UIColor(red:0.11, green:0.15, blue:0.18, alpha:1.0)
        menuDisappear()
        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self

        
//        self.hideKeyboardWhenTappedAround()
        
        // label setup
        self.primaryLbl.text = localsearchinfo.pamount
        self.localLbl.text = localsearchinfo.lamount
        self.otherLbl.text = localsearchinfo.oamount
        self.pageNoLbl.text = localsearchinfo.pagenoamount
        
        
        loadmoreLbl.isHidden = true
        splitView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(menuDis), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadingSprin), name: NSNotification.Name(rawValue: "startSpin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSprin), name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetNavbar), name: NSNotification.Name(rawValue: "resetNavbar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNavbarShareBtn), name: NSNotification.Name(rawValue: "setNavbarShareBtn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeShareBtn), name: NSNotification.Name(rawValue: "removeShareBtn"), object: nil)
   
        //control side menu height when need to suit large screen (full side menu require)
        if (menu.frame.height >= 580) {
            menu.frame.size.height = 580
        } else if (view.frame.height >= 800) {
            menu.frame.size.height = 580
        }
        
//        tableDisplay.separatorColor = UIColor.orange
        

        
        //check the iOS version
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
 
        
        // detect the screen size to setup the split screen
        view.sizeToFit()
        if (view.frame.width >= 1024) {
//            print("\n\n view width: \(view.frame.width) \(view.frame.height)\n\ntable Trailing: \(self.view.frame.width*2/3)\n\n")
             self.tabTrailing.constant = self.view.frame.width*2/3
             self.splLeading.constant = self.view.frame.width/3 + 10
            
//             setNavbarShareBtn()
             splitView.isHidden = false
             menu.isHidden = true
        } else {
//            self.tabTrailing.constant = 7
 
            splitView.isHidden = true
//            menu.isHidden = false
        }
        
//        setNavBar()

        //replace navigation back button with customise back button
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.backToSearchPage(sender:)))
        
        //remove extra separator line in table view
        self.tableDisplay.tableFooterView = UIView()
        self.tableDisplay.tableFooterView?.backgroundColor = UIColor.clear
        
        defaultOrder()
    }
    
    @objc func menuDis() {
        self.menuDisappear()
    }
    
    @objc func loadingSprin() {
        self.showSpinner(onView: self.view)
    }
    @objc func removeSprin() {
        self.removeSpinner()
    }
    @objc func resetNavbar() {
        setNavBar()
    }
    
    
    //handle the screen size when did rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        splitViewSetup()
        
        if (self.view.bounds.height > self.view.bounds.width) {
            menuDisappear()
        } else if (self.view.bounds.width > self.view.bounds.height) {
            menuDisappear()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menuDisappear()
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.enableAllOrientation = true
        }
//        tableDisplay.estimatedRowHeight = 130
//        tableDisplay.rowHeight = UITableView.automaticDimension
        
//        if (view.frame.width >= 1024) {
//
////             setNavbarShareBtn()
//
//        } else {
            setNavBar()
//        }
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
//            print("UIDevice")
            let indexPath = IndexPath(row: 0, section: 0)
            tableDisplay.selectRow(at: indexPath, animated: true, scrollPosition: .top)
//            tableDisplay.allowsSelection = true
        } else {
//            tableDisplay.allowsSelection = false
        }
        
        
        //unselect after returning back to this page
        if let indexPath = self.tableDisplay.indexPathForSelectedRow{             self.tableDisplay.deselectRow(at: indexPath, animated: animated)         }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        tableDisplay.reloadData()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.enableAllOrientation = false
        
//        if self.isMovingFromParent
//         {
//             //On click of back or swipe back
//            print("pressed back1")
//            let loginJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//            self.navigationController?.pushViewController(loginJump!, animated: true)
//         }
 
    }
    
    //for the view sds button inside of cell (currently not using)
//    @IBAction func sdsViewBtnTapped(_ sender: UIButton) {
//
//        //get row number
//
//        localcurrentSDS.sdsRowNo = sender.tag
//
//        if self.menuView.isHidden == true {
//            menuAppear()
//
//        } else if self.menuView.isHidden == false {
//            menuDisappear()
//
//        }
//    }
    
    //set customise back button action
    @objc func backToSearchPage(sender: AnyObject) {
        let backJump = self.storyboard?.instantiateViewController(withIdentifier: "SearchPage") as? SearchPage_VC
//        self.navigationController?.popToViewController(backJump!, animated: true)
//        self.navigationController?.popViewController(animated: true)
        
        self.navigationController?.pushViewController(backJump!, animated: true)
    }
    
    func setNavBar() {
        
        //change background color
        DispatchQueue.main.async {
            
            //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white
                    
            //change navigation bar text color and font
            //        navigationItem.title = "CLASSIFICATION"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
            self.navigationItem.title = "SEARCH RESULT"
            
            // set right item to make title view in the center
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "    ", style: .plain, target: self, action: .none)
            
            
        }
                //setup the company logo
//                if (localclientinfo.clientlogo != "") {

                    
        //            let comLogo = localclientinfo.clientlogo.toImage()
        //            let wd = (comLogo?.size.width)!
        //            let ht = (comLogo?.size.height)!
                    
        //            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: wd, height: ht))
        //            imageView.contentMode = .scaleAspectFit
                    
        //            imageView.image = comLogo
        //            navigationItem.titleView?.backgroundColor = UIColor.clear
        //            navigationItem.titleView = imageView
                    
//                } else {
//                    let comLogo = UIImage(named: "CSI-Logo")
//                    navigationItem.titleView = UIImageView(image: comLogo)
//                }

    }
    
    @objc func setNavbarShareBtn() {
        let btnShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBtnTapped))
        self.navigationItem.rightBarButtonItem = btnShare
    }
    
    //create share btn function
    @IBAction func shareBtnTapped() {
        

        let activityVC = UIActivityViewController(activityItems: [localcurrentSDS.pdfData!], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @objc func removeShareBtn() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "    ", style: .plain, target: self, action: .none)
    }
    
    func splitViewSetup() {
//        view.sizeToFit()
        if (view.frame.height >= 1024) {
//            print("\n\n view width: \(view.frame.width) \(view.frame.height)\n\ntable Trailing: \(self.view.frame.width*2/3)\n\n")
             self.tabTrailing.constant = self.view.frame.height*2/3
             self.splLeading.constant = self.view.frame.height/3 + 10
            
//            tableDisplay.updateConstraints()
//            splitView.updateConstraints()
            
             splitView.isHidden = false
             menu.isHidden = true
        } else {
            self.tabTrailing.constant = 7
//            tableDisplay.updateConstraints()
//            splitView.updateConstraints()
            splitView.isHidden = true
//            menu.isHidden = false
        }
    }
    
    
    // menu appear
    func menuAppear() {

        UIView.animate(withDuration: 0.5, animations:  {
            
            self.menu.isHidden = false
            if (self.view.bounds.width > 800) {
                self.menu.frame.origin.x = self.view.bounds.width - 181
            } else {
                self.menu.frame.origin.x = self.view.bounds.width - 131
            }
            
        }, completion: nil)
        
        
    }
    
    //menu disappear
    func menuDisappear() {

        UIView.animate(withDuration: 0.2, animations: {
            self.menu.isHidden = true
            self.menu.frame.origin.x = self.view.bounds.width
            }, completion: nil)
        
    }
    //sort parameters
    var localsearchFilterData :[item] = []
    var localsearchData1 = [item]()
    var localsearchValue = item()
    
    //default sort order - synonym product name and issue date
    func defaultOrder() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for i in localsearchinfo.results {
            localsearchValue.sdsno = i.sdsno
            localsearchValue.synno = i.synno
            localsearchValue.company = i.company
            localsearchValue.prodname = i.prodname
            localsearchValue.prodtype = i.prodtype
            localsearchValue.ispartial = i.ispartial
            localsearchValue.ps = i.ps
            localsearchValue.unno = i.unno
            localsearchValue.subrisk1 = i.subrisk1
            localsearchValue.prodcode = i.prodcode
            localsearchValue.dgclass = i.dgclass
            localsearchValue.GHS_Pictogram = i.GHS_Pictogram
            localsearchValue.Com_Country = i.Com_Country
            localsearchValue.haz = i.haz
            localsearchValue.issueDate = i.issueDate
            
            localsearchData1.append(localsearchValue)
        }
        
        localsearchFilterData = localsearchData1.sorted {
            if $0.prodname == $1.prodname {
               return ($1.issueDate < $0.issueDate)
            }
               return ($0.prodname < $1.prodname)
        }
    }
    
}
    


extension SearchTablePage_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchFilterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if localsearchFilterData.isEmpty == true {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
            cell?.SupplierLbl.text = "No result"
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
//            DispatchQueue.main.async {
                            cell?.name.text = localsearchFilterData[indexPath.row].prodname
                            cell?.SupplierLbl.text = localsearchFilterData[indexPath.row].company
            cell?.IssueDateLbl.text = dateFormatter.string(from: localsearchFilterData[indexPath.row].issueDate)
                            cell?.UNNoLbl.text = localsearchFilterData[indexPath.row].unno
                            cell?.prodCLbl.text = localsearchFilterData[indexPath.row].prodcode
                //            cell?.dgcLbl.text = localsearchinfo.results[indexPath.row].dgclass
                //            cell?.psLbl.text = localsearchinfo.results[indexPath.row].ps
                //            cell?.hazLbl.text = localsearchinfo.results[indexPath.row].haz
                            if (localsearchFilterData[indexPath.row].Com_Country.isEmpty == true) {
                                cell?.countryLbl.text = "Australia"
                            } else {
                               cell?.countryLbl.text = localsearchFilterData[indexPath.row].Com_Country
                            }
                
                // setup the GHS pictograms in cells
                            
                            var picArray: Array<Any> = []
                            cell?.ghsImg1.image = nil
                            cell?.ghsImg2.image = nil
                            cell?.ghsImg3.image = nil
                            cell?.ghsImg4.image = nil
                            cell?.ghsImg5.image = nil
                            
                            cell?.img1Height.constant = 0
                            cell?.issImg1Gap.constant = 0
                            cell?.img4Height.constant = 0
                            cell?.issImg4Gap.constant = 0
                            cell?.img1BotGap.constant = 10
                            
                            if (localsearchFilterData[indexPath.row].GHS_Pictogram.isEmpty == false) {
                                picArray = localsearchFilterData[indexPath.row].GHS_Pictogram.components(separatedBy: ",")
                            }
//                            print(localsearchinfo.results[indexPath.row].GHS_Pictogram)
                            
                            if picArray.count != 0 {
                                    var cArray: [Any?] = []
                                    var imgCode: String?

                                    for index in 0..<(picArray.count) {

                                        let imgName = picArray[index]
                                        let imgNameFix = (imgName as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                                        if (imgNameFix == "flame") {

                                            imgCode = "GHS02"
                                            cArray.append(imgCode!)
                                            
                                        } else if (imgNameFix == "skull and crossbones") {

                                            imgCode = "GHS06"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "flame over circle") {

                                            imgCode = "GHS03"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "exclamation mark") {

                                            imgCode = "GHS07"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "environment") {

                                            imgCode = "GHS09"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "health hazard") {

                                            imgCode = "GHS08"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "corrosion") {

                                            imgCode = "GHS05"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "gas cylinder") {

                                            imgCode = "GHS04"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "exploding bomb") {

                                            imgCode = "GHS01"
                                            cArray.append(imgCode!)
                                            
                                        } else {
                //                            print(imgNameFix)
                                        }
                                        
                                    }

//                                print(cArray.count)
                                    if cArray.count == 1 {
                                        
                                        cell?.img1Height.constant = 60
                                        cell?.issImg1Gap.constant = 20
                                        cell?.img4Height.constant = 0
                                        cell?.issImg4Gap.constant = 0
                                        cell?.img1BotGap.constant = 10
                                        
                                        cell?.ghsImg1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)

                                    } else if cArray.count == 2 {
                                        
                                        cell?.img1Height.constant = 60
                                        cell?.issImg1Gap.constant = 20
                                        cell?.img4Height.constant = 0
                                        cell?.issImg4Gap.constant = 0
                                        cell?.img1BotGap.constant = 10
                                        
                                        cell?.ghsImg1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                                        cell?.ghsImg2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                                    } else if cArray.count == 3 {
                                        
                                        cell?.img1Height.constant = 60
                                        cell?.issImg1Gap.constant = 20
                                        cell?.img4Height.constant = 0
                                        cell?.issImg4Gap.constant = 0
                                        cell?.img1BotGap.constant = 10
                                        
                                        cell?.ghsImg1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                                        cell?.ghsImg2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                                        cell?.ghsImg3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                                    } else if cArray.count == 4 {
                                        
                                        
                                        cell?.img1Height.constant = 60
                                        cell?.issImg1Gap.constant = 20
                                        cell?.img4Height.constant = 60
                                        cell?.issImg4Gap.constant = 60
                                        cell?.img1BotGap.constant = 65
                                        

                                            cell?.ghsImg1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                                            cell?.ghsImg2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                                            cell?.ghsImg3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                                            cell?.ghsImg4.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)

                                    } else if cArray.count == 5 {


                                        
                                        cell?.img1Height.constant = 60
                                        cell?.issImg1Gap.constant = 20
                                        cell?.img4Height.constant = 60
                                        cell?.issImg4Gap.constant = 60
                                        cell?.img1BotGap.constant = 65
                         
                                            cell?.ghsImg1.image = UIImage(named: Bundle.main.path(forResource: cArray[0] as? String, ofType: "png")!)
                                            cell?.ghsImg2.image = UIImage(named: Bundle.main.path(forResource: cArray[1] as? String, ofType: "png")!)
                                            cell?.ghsImg3.image = UIImage(named: Bundle.main.path(forResource: cArray[2] as? String, ofType: "png")!)
                                            cell?.ghsImg4.image = UIImage(named: Bundle.main.path(forResource: cArray[3] as? String, ofType: "png")!)
                                            cell?.ghsImg5.image = UIImage(named: Bundle.main.path(forResource: cArray[4] as? String, ofType: "png")!)

                                    }
                                } else {
                                    cell?.ghsImg1.image = nil
                                    cell?.ghsImg2.image = nil
                                    cell?.ghsImg3.image = nil
                                    cell?.ghsImg4.image = nil
                                    cell?.ghsImg5.image = nil

                                    
                                    cell?.img1Height.constant = 0
                                    cell?.issImg1Gap.constant = 0
                                    cell?.img4Height.constant = 0
                                    cell?.issImg4Gap.constant = 0
                                }
                //            end setup GHS pictograms
            
            
            //setup name type pic
            if localsearchFilterData[indexPath.row].prodtype == "P" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Primary")
            } else if localsearchFilterData[indexPath.row].prodtype == "O" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Other")
            } else if localsearchFilterData[indexPath.row].prodtype == "L" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Local")
            }
            
            
            let image = UIImage(named: "CSI-CFBC")
            let imageView = UIImageView(image: image)
            cell?.backgroundView = imageView
            cell?.backgroundColor = UIColor.clear
            
            
            
            //setup cell color
            
//            if indexPath.row % 2 == 0 {
//              //cell?.backgroundColor = UIColor.white
////            cell?.backgroundColor = UIColor.darkGray
//                cell?.backgroundColor = UIColor(red:0.11, green:0.15, blue:0.18, alpha:1.0)
//            } else {
//                cell?.backgroundColor = UIColor.groupTableViewBackground
//            }
//            cell?.backgroundColor = UIColor(red:0.11, green:0.15, blue:0.18, alpha:1.0)
            cell?.layer.cornerRadius = 10


            //set row number of button that inside cell when tap
//            cell?.sdsBtn.tag = indexPath.row
//            cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
            
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                //set background display image/color
                let selectedView = UIView()
//                selectedView.backgroundColor = UIColor(red:0.10, green:0.10, blue:0.09, alpha:1.0)
                selectedView.backgroundColor = UIColor.clear
                cell?.selectedBackgroundView = selectedView
                
                //set text display color
                cell?.name.highlightedTextColor = UIColor.orange
                cell?.SupplierLbl.highlightedTextColor = UIColor.orange
                cell?.IssueDateLbl.highlightedTextColor = UIColor.orange
                cell?.isslbl.highlightedTextColor = UIColor.orange
                cell?.UNNoLbl.highlightedTextColor = UIColor.orange
                cell?.unlbl.highlightedTextColor = UIColor.orange
                cell?.prodCodeLbl.highlightedTextColor = UIColor.orange
                cell?.prodCLbl.highlightedTextColor = UIColor.orange
                cell?.countryLbl.highlightedTextColor = UIColor.orange
            } else {
//                cell?.selectionStyle = .none
            }
               

            return cell!
        }
        

    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //pass the synno number
        localcurrentSDS.sdsNo = localsearchinfo.results[indexPath.row].synno

//        print(localcurrentSDS.sdsNo ?? "")
        view.sizeToFit()

        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        // controll the animation of side menu (click on the same row - no change)
        if (view.frame.width >= 1024) {

//            menu.isHidden = true
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideContainer"), object: nil)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showSDS"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
            csiWCF_VM().callSDS_FA(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                if output.contains("true") {
                    DispatchQueue.main.async {
                        csiWCF_VM().callSDS_Trans(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                            if output.contains("true") {
                                DispatchQueue.main.async {
                                    csiWCF_VM().callSDS_GHS(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                                        if output.contains("true") {
                                            DispatchQueue.main.async {
//                                                print("tapped")
//                                                    DispatchQueue.main.async {
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callPerView"), object: nil)
//                                                        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSGHSN") as? SDSViewCFGHSN_VC
//                                                        self.navigationController?.pushViewController(sdsJump!, animated: true)
//                                                    }
                                                self.splitView.setNeedsLayout()
                                                self.splitView.layoutIfNeeded()
                                            }
                                        }
                                    }
                                }
                            }else {
//                            print("Something wrong!")
                            }
                        }
                    }

                }else {
//                    print("Something wrong!")
                }

            }



        } else if (view.frame.width < 1024) {

            // call the menu
//            if self.menu.isHidden == true {
//
//                menuAppear()
//                selectedthecellno = indexPath.row
//            }
//            else if self.menu.isHidden == false && indexPath.row != selectedthecellno {
//
//                menuDisappear()
//                menuAppear()
//                selectedthecellno = indexPath.row
//            } else if self.menu.isHidden == false && indexPath.row == selectedthecellno {
//
//                menuAppear()
//            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
            csiWCF_VM().callSDS_FA(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                if output.contains("true") {
                    DispatchQueue.main.async {
                        csiWCF_VM().callSDS_Trans(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                            if output.contains("true") {
                                DispatchQueue.main.async {
                                    csiWCF_VM().callSDS_GHS(sdsno: localcurrentSDS.sdsNo, session: session) { (output) in
                                        if output.contains("true") {
                                            DispatchQueue.main.async {
//                                                print("tapped")
                                                    DispatchQueue.main.async {
                                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeSpin"), object: nil)
                                                        let sdsJump = self.storyboard?.instantiateViewController(withIdentifier: "SDSGHSN") as? SDSViewCFGHSN_VC
                                                        self.navigationController?.pushViewController(sdsJump!, animated: true)
                                                    }
                                            }
                                        }
                                    }
                                }
                            }else {
                            print("Something wrong!")
                            }
                        }
                    }

                }else {
                    print("Something wrong!")
                }

            }

        }
        

    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
//        cell?.name.textColor = UIColor.white
//        cell?.countryLbl.textColor = UIColor.white
//        cell?.isslbl.textColor = UIColor.white
//        cell?.IssueDateLbl.textColor = UIColor.white
//        cell?.UNNoLbl.textColor = UIColor.white
//        cell?.unlbl.textColor = UIColor.white
//        cell?.prodCodeLbl.textColor = UIColor.white
//        cell?.prodCLbl.textColor = UIColor.white
//
//    }


    
    
    
    // change the height to expand tableDisplay value
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 125
//
//    }
    
    // swipe to delete the row function (or can add more function like like)
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            localsearchinfo.results.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if self.menu.isHidden == false {
            menuDisappear()
            self.menu.isHidden = true
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if (maximumOffset - currentOffset <= -70.0) {
//            print(localsearchinfo.totalamount!)
            //old way
//            if (localsearchinfo.cpage < localsearchinfo.totalPage) {
//                loadmoreLbl.isHidden = false
//                loadmoreLbl.text = "Drop to load more..."
//            } else if (localsearchinfo.cpage >= localsearchinfo.totalPage && localsearchinfo.totalamount < 250) {
//                loadmoreLbl.isHidden = false
//                loadmoreLbl.text = "All data has been loaded."
//            } else if ( localsearchinfo.totalamount > 249) {
//                loadmoreLbl.isHidden = false
//                loadmoreLbl.text = "Only 250 results have been displayed.\n Please refine your search criteria for more accurate results."
//            }
            
 if (localsearchinfo.results.count < 250) {
                loadmoreLbl.isHidden = false
                loadmoreLbl.text = "All data has been loaded."
            } else if ( localsearchinfo.results.count > 249) {
                loadmoreLbl.isHidden = false
                loadmoreLbl.text = "Only 250 results have been displayed.\n Please refine your search criteria for more accurate results."
            }
            
        } else {
            loadmoreLbl.isHidden = true
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        let minimumOffset: CGFloat = 0.0
        
        loadmoreLbl.isHidden = true
        
        //table bottom reload function setup
        if (maximumOffset - currentOffset <= -70.0) {

            if (localsearchinfo.cpage < localsearchinfo.totalPage) {
                
                self.showSpinner(onView: self.view)
                localsearchinfo.cpage += 1
                
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
                csiWCF_VM().callSearch(pnameInputData: localcriteriainfo.searchValue, supInputData: localcriteriainfo.supSearchValue, pcodeInputData: localcriteriainfo.pcodeSearchValue, barcode: "", session: session ) { (completionReturnData) in
                    if completionReturnData == true {
                        DispatchQueue.main.async {
                            self.removeSpinner()
                            self.pageNoLbl.text = localsearchinfo.pagenoamount
//                            self.tableDisplay.setContentOffset(.zero, animated: true)
                            self.tableDisplay.reloadData()

                        }
                    } else {
                        DispatchQueue.main.async {
                            self.removeSpinner()
                            self.showAlert(title: "Failed", message: "Cannot found the search results.")
                        }
                    }
                }
            } else {
                
            }
        }
        
        //table top reload setup
//        if (currentOffset - minimumOffset <= -80.0 ) {
//            if localsearchinfo.cpage <= 1 {
//
//            } else {
//                self.showSpinner(onView: self.view)
//                localsearchinfo.cpage -= 1
//
//
//                csiWCF_VM().callSearch(inputData: localcriteriainfo.searchValue) { (completionReturnData) in
//                    if completionReturnData == true {
//                        DispatchQueue.main.async {
//                            self.removeSpinner()
//                            self.pageNoLbl.text = localsearchinfo.pagenoamount
//                            self.tableDisplay.reloadData()
//                            self.tableDisplay.setContentOffset(.zero, animated: false)
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.removeSpinner()
//                            self.showAlert(title: "Failed", message: "Cannot found the search results.")
//                        }
//                    }
//                }
//            }
//        }
        
    }
    
}

extension SearchTablePage_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
