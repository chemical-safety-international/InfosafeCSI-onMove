//
//  TablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class SearchTablePage_VC: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var tableDisplay: UITableView!

    @IBOutlet weak var primaryLbl: UILabel!
    @IBOutlet weak var localLbl: UILabel!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var pageNoLbl: UILabel!
    
    @IBOutlet weak var menu: UIView!
    
    
    @IBOutlet weak var loadmoreLbl: UILabel!

    
    @IBOutlet weak var splitView: UIView!
    
    var selectedIndex:Bool = false;

    var selectedthecellno = 0
    var testrow = 0
    
    @IBOutlet weak var tabTrailing: NSLayoutConstraint!
    //    @IBOutlet weak var tabTrailing: NSLayoutConstraint!
    @IBOutlet weak var splitLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableDisplay.contentInsetAdjustmentBehavior = .never
//        self.tableDisplay.contentInset = self.view.safeAreaInsets
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
             self.splitLeading.constant = self.view.frame.width/3
            
            
             splitView.isHidden = false
             menu.isHidden = true
        } else {
//            self.tabTrailing.constant = 7
 
            splitView.isHidden = true
            menu.isHidden = false
        }
        
//        setNavBar()
        
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
//        tableDisplay.estimatedRowHeight = 130
//        tableDisplay.rowHeight = UITableView.automaticDimension
        setNavBar()
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        tableDisplay.reloadData()
//    }
    
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
    
    func setNavBar() {
        //change background color
        DispatchQueue.main.async {
//            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationController?.navigationBar.barTintColor = UIColor.white
//            self.navigationController?.navigationBar.tintColor = UIColor.black
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black]
            
            
                   //change background color & back button color
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white
                    
                    //change navigation bar text color and font
            //        navigationItem.title = "CLASSIFICATION"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
            
            
            self.navigationItem.title = "SEARCH RESULT"

            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "    ", style: .plain, target: self, action: .none)
            
            
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
    
    func splitViewSetup() {
//        view.sizeToFit()
        if (view.frame.height >= 1024) {
            print("\n\n view width: \(view.frame.width) \(view.frame.height)\n\ntable Trailing: \(self.view.frame.width*2/3)\n\n")
             self.tabTrailing.constant = self.view.frame.height*2/3
             self.splitLeading.constant = self.view.frame.height/3
            
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
    
    func menuDisappear() {

        UIView.animate(withDuration: 0.2, animations: {
            self.menu.isHidden = true
            self.menu.frame.origin.x = self.view.bounds.width
            }, completion: nil)
        
        
    }
    
}
    


extension SearchTablePage_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchinfo.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if localsearchinfo.results.isEmpty == true {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
            cell?.SupplierLbl.text = "No result"
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
           
            
//            DispatchQueue.main.async {
                            cell?.name.text = localsearchinfo.results[indexPath.row].prodname
                            cell?.SupplierLbl.text = localsearchinfo.results[indexPath.row].company
                            cell?.IssueDateLbl.text = localsearchinfo.results[indexPath.row].issueDate
                            cell?.UNNoLbl.text = localsearchinfo.results[indexPath.row].unno
                            cell?.prodCLbl.text = localsearchinfo.results[indexPath.row].prodcode
                //            cell?.dgcLbl.text = localsearchinfo.results[indexPath.row].dgclass
                //            cell?.psLbl.text = localsearchinfo.results[indexPath.row].ps
                //            cell?.hazLbl.text = localsearchinfo.results[indexPath.row].haz
                            if (localsearchinfo.results[indexPath.row].Com_Country.isEmpty == true) {
                                cell?.countryLbl.text = "Australia"
                            } else {
                               cell?.countryLbl.text = localsearchinfo.results[indexPath.row].Com_Country
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
                            
                            if (localsearchinfo.results[indexPath.row].GHS_Pictogram.isEmpty == false) {
                                picArray = localsearchinfo.results[indexPath.row].GHS_Pictogram.components(separatedBy: ",")
                            }
//                            print(localsearchinfo.results[indexPath.row].GHS_Pictogram)
                            
                            if picArray.count != 0 {
                                    var cArray: [Any] = []
                                    var imgCode: String!

                                    for index in 0..<(picArray.count) {

                                        let imgName = picArray[index]
                                        let imgNameFix = (imgName as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)

                                        if (imgNameFix == "Flame") {

                                            imgCode = "GHS02"
                                            cArray.append(imgCode!)
                                            
                                        } else if (imgNameFix == "Skull and crossbones") {

                                            imgCode = "GHS06"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Flame over circle") {

                                            imgCode = "GHS03"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Exclamation mark") {

                                            imgCode = "GHS07"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Environment") {

                                            imgCode = "GHS09"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Health hazard") {

                                            imgCode = "GHS08"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Corrosion") {

                                            imgCode = "GHS05"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Gas cylinder") {

                                            imgCode = "GHS04"
                                            cArray.append(imgCode!)

                                        } else if (imgNameFix == "Exploding bomb") {

                                            imgCode = "GHS01"
                                            cArray.append(imgCode!)
                                            
                                        } else {
                //                            print(imgNameFix)
                                        }
                    
                                    }

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
            if localsearchinfo.results[indexPath.row].prodtype == "P" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Primary")
            } else if localsearchinfo.results[indexPath.row].prodtype == "O" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Other")
            } else if localsearchinfo.results[indexPath.row].prodtype == "L" {
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
        view.sizeToFit()


        // controll the animation of side menu (click on the same row - no change)
        if (view.frame.width >= 1024) {

            menu.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startSpin"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideContainer"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showSDS"), object: nil)




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
            csiWCF_VM().callSDS_FA(sdsno: localcurrentSDS.sdsNo) { (output) in
                if output.contains("true") {
                    DispatchQueue.main.async {
                        csiWCF_VM().callSDS_Trans(sdsno: localcurrentSDS.sdsNo) { (output) in
                            if output.contains("true") {
                                DispatchQueue.main.async {
                                    csiWCF_VM().callSDS_GHS(sdsno: localcurrentSDS.sdsNo) { (output) in
                                        if output.contains("true") {
                                            DispatchQueue.main.async {
                                                print("tapped")
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

            if (localsearchinfo.cpage < localsearchinfo.totalPage) {
                loadmoreLbl.isHidden = false
                loadmoreLbl.text = "Drop to load more..."
            } else if (localsearchinfo.cpage >= localsearchinfo.totalPage) {
                loadmoreLbl.isHidden = false
                loadmoreLbl.text = "All data has been loaded."
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
                
                
                csiWCF_VM().callSearch(pnameInputData: localcriteriainfo.searchValue, supInputData: localcriteriainfo.supSearchValue, pcodeInputData: localcriteriainfo.pcodeSearchValue ) { (completionReturnData) in
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
