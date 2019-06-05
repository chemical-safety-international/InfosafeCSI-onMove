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

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    @IBOutlet weak var viewSdsBtn: UIButton!
    
    var selectedIndex:Bool = false;
    var select = -1

    var rowno = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.menuView.isHidden = true
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self
        
//        tableDisplay.estimatedRowHeight = 100
//        tableDisplay.rowHeight = UITableView.automaticDimension
        
        viewSdsBtn.layer.cornerRadius = 10
        
        self.hideKeyboardWhenTappedAround()
        self.countLabel.text = localsearchinfo.pdetails
        menuView.center.x += view.bounds.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableDisplay.estimatedRowHeight = 145
        tableDisplay.rowHeight = UITableView.automaticDimension
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func loadList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.tableDisplay.reloadData()
        }
    }
    
    @IBAction func sdsViewBtnTapped(_ sender: UIButton) {
        
        //get row number
//        let buttonRow = sender.tag
//
//        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
//
//        localcurrentSDS.sdsNo = localsearchinfo.results[buttonRow].synno
//
//        self.navigationController?.pushViewController(sdsJump!, animated: true)
        
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
    
    @IBAction func menuCloseBtnTapped(_ sender: Any) {
        
        self.menuView.isHidden = true
    }
    
    func menuAppear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.center.x -= self.view.bounds.width
            }, completion: nil)
    }
    
    func menuDisappear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.center.x += self.view.bounds.width
        }, completion: nil)
    }
    
}
    


extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchinfo.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell

//        localsearchinfo.details = ("SDS No.: \(localsearchinfo.results[indexPath.row].sdsno ?? "") \nCompany Name: \(localsearchinfo.results[indexPath.row].company ?? "") \nIssue Date: \( localsearchinfo.results[indexPath.row].issueDate ?? "") \nUNNo: \(localsearchinfo.results[indexPath.row].unno ?? "")")
        
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
        
        
        cell?.name.text = localsearchinfo.results[indexPath.row].prodname
//        cell?.details.text = localsearchinfo.details
        
        //set row number of button that inside cell when tap
        cell?.sdsBtn.tag = indexPath.row
        cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        localcurrentSDS.sdsNo = localsearchinfo.results[indexPath.row].synno
//        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
//        self.navigationController?.pushViewController(sdsJump!, animated: true)
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
