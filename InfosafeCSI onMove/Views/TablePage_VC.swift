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
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var viewSdsBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    var selectedIndex:Bool = false;
    var select = -1

    var rowno = 0
    var selectedthecellno = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.menuView.isHidden = true
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self
//        tableDisplay.layer.cornerRadius = 10
        
        
        viewSdsBtn.layer.cornerRadius = 10
        
        //side menu setup
        menuView.layer.cornerRadius = 10
        menuView.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
        menuView.center.x += view.bounds.width
        
        self.hideKeyboardWhenTappedAround()
        
        // label setup
        self.primaryLbl.text = localsearchinfo.pamount
        self.localLbl.text = localsearchinfo.lamount
        self.otherLbl.text = localsearchinfo.oamount
        self.pageNoLbl.text = localsearchinfo.pagenoamount
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tableDisplay.estimatedRowHeight = 145
//        tableDisplay.rowHeight = UITableView.automaticDimension
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func loadList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.tableDisplay.reloadData()
        }
    }
    
    //currently not using
    @IBAction func sdsViewBtnTapped(_ sender: UIButton) {
        
        //get row number
        
        localcurrentSDS.sdsRowNo = sender.tag
        
        if self.menuView.isHidden == true {
            menuAppear()
            self.menuView.isHidden = false
        } else if self.menuView.isHidden == false {
            menuDisappear()
            self.menuView.isHidden = true
        }
        
        
    }
    
    @IBAction func viewSdsBtnTapped(_ sender: Any) {

        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC

        localcurrentSDS.sdsNo = localsearchinfo.results[localcurrentSDS.sdsRowNo].synno

        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    

    @IBAction func closeBtnTapped(_ sender: Any) {
        menuDisappear()
        self.menuView.isHidden = true
    }
    
    func menuAppear() {
        UIView.animate(withDuration: 0.8, animations: {
            self.menuView.center.x -= self.view.bounds.width
            }, completion: nil)
        self.menuView.isHidden = false
    }
    
    func menuDisappear() {
        UIView.animate(withDuration: 0.4, animations: {
            self.menuView.center.x += self.view.bounds.width
        }, completion: nil)
        self.menuView.isHidden = true
    }
    
}
    


extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchinfo.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        
        cell?.SDSNoLbl.text = localsearchinfo.results[indexPath.row].sdsno
        cell?.SupplierLbl.text = localsearchinfo.results[indexPath.row].company
        cell?.IssueDateLbl.text = localsearchinfo.results[indexPath.row].issueDate
        cell?.UNNoLbl.text = localsearchinfo.results[indexPath.row].unno
        
        //setup name type pic
        if localsearchinfo.results[indexPath.row].prodtype == "P" {
            cell?.nameType?.image = UIImage(named: "ProdNameType-Primary")
        } else if localsearchinfo.results[indexPath.row].prodtype == "O" {
            cell?.nameType?.image = UIImage(named: "ProdNameType-Other")
        } else if localsearchinfo.results[indexPath.row].prodtype == "L" {
            cell?.nameType?.image = UIImage(named: "ProdNameType-Local")
        }
        
        //setup cell color
        
        if rowno == 1 {
            cell?.backgroundColor = UIColor.white

            rowno = 0
        } else if rowno == 0 {
            cell?.backgroundColor = UIColor.groupTableViewBackground
            rowno = 1
        }
        
        cell?.layer.cornerRadius = 10
        cell?.name.text = localsearchinfo.results[indexPath.row].prodname
        
        //set row number of button that inside cell when tap
        cell?.sdsBtn.tag = indexPath.row
        cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.view.endEditing(true)
        
        localcurrentSDS.sdsNo = localsearchinfo.results[indexPath.row].synno
        if let selectedCell = tableView.cellForRow(at: indexPath) as? TableViewCell {

            selectedCell.contentView.backgroundColor = UIColor.init(red: 0.98, green: 0.80, blue: 0.61, alpha: 1)
           // selectedCell.contentView.backgroundColor = UIColor.init(red: 0.96, green: 0.70, blue: 0.42, alpha: 1)
        }
        
        
        if self.menuView.isHidden == true {
            menuAppear()
            self.menuView.isHidden = false
            selectedthecellno = indexPath.row
        }        else if self.menuView.isHidden == false && indexPath.row != selectedthecellno {
            menuDisappear()
            menuAppear()
////            self.menuView.isHidden = true
        }

    }
    
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 125

    }
    
    // swipe to delete the row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            localsearchinfo.results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.menuView.isHidden == false {
            menuDisappear()
            self.menuView.isHidden = true
        }

    }
    
    
}
