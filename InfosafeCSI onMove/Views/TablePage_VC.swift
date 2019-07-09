//
//  TablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class TablePage_VC: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var tableDisplay: UITableView!

    @IBOutlet weak var primaryLbl: UILabel!
    @IBOutlet weak var localLbl: UILabel!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var pageNoLbl: UILabel!
    
    @IBOutlet weak var menu: UIView!
    
    
    @IBOutlet weak var loadmoreLbl: UILabel!
    @IBOutlet weak var menuUIView: UIView!
    
    @IBOutlet weak var splitView: UIView!
    
    @IBOutlet weak var tableTrailing: NSLayoutConstraint!
    
    var selectedIndex:Bool = false;

//    var rowno = 0
    var selectedthecellno = 0
    
//    var screenHeight = 0
//    var screenWidth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuDisappear()
        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self

        
        self.hideKeyboardWhenTappedAround()
        
        // label setup
        self.primaryLbl.text = localsearchinfo.pamount
        self.localLbl.text = localsearchinfo.lamount
        self.otherLbl.text = localsearchinfo.oamount
        self.pageNoLbl.text = localsearchinfo.pagenoamount
        
        
        loadmoreLbl.isHidden = true
        splitView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(menuDis), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
//        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "scroll"), object: nil)
//        localtablesize.tableHeight = menu.frame.height
        if (menu.frame.height >= 580) {
            menu.frame.size.height = 580
        } else if (view.frame.height >= 800) {
            menu.frame.size.height = 580
        }
        

        
//        if (view.frame.width >= 1100) {
//            tableDisplay.frame.size.width = view.frame.width/2
//            tableDisplay.contentSize.width = view.frame.width/2
//            tableTrailing.constant = view.frame.width/2
//            splitView.frame.origin.y = tableDisplay.frame.origin.y
//            splitView.frame.origin.x = tableDisplay.frame.size.width
//            splitView.frame.size.width = tableDisplay.frame.width
//            splitView.isHidden = false
//        } else if (view.frame.width < 1100) {
//            tableDisplay.frame.size.width = view.frame.width
//            tableDisplay.contentSize.width = view.frame.width
//            tableTrailing.constant = 7
//            splitView.isHidden = true
//        }
        
    }
    
    @objc func menuDis() {
        self.menuDisappear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print(view.frame.width)
        print(view.frame.height)
        
        if (self.view.bounds.height > self.view.bounds.width) {
            menuDisappear()
        } else if (self.view.bounds.width > self.view.bounds.height) {
            menuDisappear()
        }
        
        if (view.frame.height >= 1024) {
            tableDisplay.frame.size.width = view.frame.height/2
//            tableDisplay.contentSize.width = view.frame.height/2
            tableTrailing.constant = view.frame.height/2
//            splitView.frame.origin.y = tableDisplay.frame.origin.y
//            splitView.frame.origin.x = tableDisplay.frame.size.width
//            splitView.frame.size.width = tableDisplay.frame.width
//            splitView.frame.size.height = tableDisplay.frame.height
            splitView.isHidden = false
        } else if (view.frame.height < 1024) {
            tableDisplay.frame.size.width = view.frame.width
            tableDisplay.contentSize.width = view.frame.width
            tableTrailing.constant = 7
            splitView.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menuDisappear()
        self.view.endEditing(true)
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
    


extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
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
            
            cell?.SupplierLbl.text = localsearchinfo.results[indexPath.row].company
            cell?.IssueDateLbl.text = localsearchinfo.results[indexPath.row].issueDate
            cell?.UNNoLbl.text = localsearchinfo.results[indexPath.row].unno
            cell?.prodCLbl.text = localsearchinfo.results[indexPath.row].prodcode
            cell?.dgcLbl.text = localsearchinfo.results[indexPath.row].dgclass
            cell?.psLbl.text = localsearchinfo.results[indexPath.row].ps
            cell?.hazLbl.text = localsearchinfo.results[indexPath.row].haz
            
            
            //setup name type pic
            if localsearchinfo.results[indexPath.row].prodtype == "P" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Primary")
            } else if localsearchinfo.results[indexPath.row].prodtype == "O" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Other")
            } else if localsearchinfo.results[indexPath.row].prodtype == "L" {
                cell?.nameType?.image = UIImage(named: "ProdNameType-Local")
            }
            
            //setup cell color
            
            if indexPath.row % 2 == 0 {
              cell?.backgroundColor = UIColor.white
            } else {
                cell?.backgroundColor = UIColor.groupTableViewBackground
            }
            
            cell?.layer.cornerRadius = 10
            cell?.name.text = localsearchinfo.results[indexPath.row].prodname
            
            //set row number of button that inside cell when tap
//            cell?.sdsBtn.tag = indexPath.row
//            cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
            
            
            return cell!
        }
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //pass the synno number
        localcurrentSDS.sdsNo = localsearchinfo.results[indexPath.row].synno
        
        //highlight the row
        if let selectedCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
            selectedCell.contentView.backgroundColor = UIColor.init(red: 0.98, green: 0.80, blue: 0.61, alpha: 1)
        }
        
        // controll the animation of side menu (click on the same row - no change)
        if self.menu.isHidden == true {
            menuAppear()
            selectedthecellno = indexPath.row
        }
        else if self.menu.isHidden == false && indexPath.row != selectedthecellno {
            menuDisappear()
            menuAppear()
            selectedthecellno = indexPath.row
        }

    }
    
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 125

    }
    
    // swipe to delete the row function
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
                
                
                csiWCF_VM().callSearch(inputData: localcriteriainfo.searchValue) { (completionReturnData) in
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
