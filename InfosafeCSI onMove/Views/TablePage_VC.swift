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
    
    
    
    var selectedIndex:Bool = false;
    var select = -1
//    var rowNo = 0
    var rowno = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self
        
//        tableDisplay.estimatedRowHeight = 100
//        tableDisplay.rowHeight = UITableView.automaticDimension
        self.hideKeyboardWhenTappedAround()
        self.countLabel.text = localsearchinfo.pdetails
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
        let buttonRow = sender.tag
        
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
    
        localcurrentSDS.sdsNo = localsearchinfo.results[buttonRow].synno
        
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
}
    


extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localsearchinfo.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell

        localsearchinfo.details = ("SDS No.: \(localsearchinfo.results[indexPath.row].sdsno ?? "") \nCompany Name: \(localsearchinfo.results[indexPath.row].company ?? "") \nIssue Date: \( localsearchinfo.results[indexPath.row].issueDate ?? "") \nUNNo: \(localsearchinfo.results[indexPath.row].unno ?? "")")
        
        //setup name type pic
        if localsearchinfo.results[indexPath.row].prodtype == "P" {
            cell?.nameType?.image = UIImage(named: "ProdName-Type-Primary")
        } else if localsearchinfo.results[indexPath.row].prodtype == "O" {
            cell?.nameType?.image = UIImage(named: "ProdName-Type-Other")
        } else if localsearchinfo.results[indexPath.row].prodtype == "L" {
            cell?.nameType?.image = UIImage(named: "ProdName-Type-Local")
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
        cell?.details.text = localsearchinfo.details
        
        //set row number of button that inside cell when tap
        cell?.sdsBtn.tag = indexPath.row
        cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
//        rowNo = indexPath.row
//
//        localcurrentSDS.sdsNo = localsearchinfo.results[rowNo].synno
        
        localcurrentSDS.sdsNo = localsearchinfo.results[indexPath.row].synno
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 135

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
    
    
}
