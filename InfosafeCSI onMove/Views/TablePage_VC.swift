//
//  TablePage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 10/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class TablePage_VC: UIViewController {

    @IBOutlet weak var tableDisplay: UITableView!
    
    var selectedIndex:Bool = false;
    var select = -1
    var rowNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableDisplay.delegate = self
        self.tableDisplay.dataSource = self
        tableDisplay.rowHeight = UITableView.automaticDimension
//        tableDisplay.estimatedRowHeight = 100
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
        //csicurrentSDS.sdsNo = csiclientsearchinfo.arrNo[rowNo]
        csicurrentSDS.sdsNo = csiclientsearchinfo.arrNo[buttonRow]
        
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
}







extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return csiclientsearchinfo.arrCompanyName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        //csiclientsearchinfo.details = ("Issue date: \(csiclientsearchinfo.arrIssueData[indexPath.row]) \n SDS No.: \(csiclientsearchinfo.arrNo[indexPath.row])")
        csiclientsearchinfo.details = ("SDS No.: \(csiclientsearchinfo.arrNo[indexPath.row])")
        
        cell?.name.text = csiclientsearchinfo.arrCompanyName[indexPath.row]
        cell?.details.text = csiclientsearchinfo.details
        
        //set row number of button that inside cell when tap
        cell?.sdsBtn.tag = indexPath.row
        cell?.sdsBtn.addTarget(self, action: #selector(sdsViewBtnTapped(_:)), for: .touchUpInside)
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        rowNo = indexPath.row
        
        csicurrentSDS.sdsNo = csiclientsearchinfo.arrNo[rowNo]
        let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
        self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
    // swipe to delete the row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            csiclientsearchinfo.arrCompanyName.remove(at: indexPath.row)
            csiclientsearchinfo.arrIssueData.remove(at: indexPath.row)
            csiclientsearchinfo.arrNo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}
