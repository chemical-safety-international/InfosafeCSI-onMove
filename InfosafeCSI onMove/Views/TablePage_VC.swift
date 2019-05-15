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
        
        tableDisplay.rowHeight = UITableView.automaticDimension
        tableDisplay.estimatedRowHeight = 100
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
    
    func beginSearch(clientid: String, infosafeid: String, input: String) {
        csiWCF_GetSDSSearchResultsPageEx(clientid: clientid, infosafeid: infosafeid, inputData: input) {
            (returnData) in
            
            if returnData.contains("false") {
                print("No data return from search")
                csiclientsearchinfo.searchstatus = false
            } else {
                csiclientsearchinfo.searchstatus = true
                let returnArray = csiWCF_SearchReturnValueFix(inValue: returnData)
                print("Success called search: \n \(returnArray.0) \n \(returnArray.1) \n \(returnArray.2)")
                
                csiclientsearchinfo.arrName = returnArray.0 as? [String]
                csiclientsearchinfo.arrDetail = returnArray.1 as? [String]
                csiclientsearchinfo.arrNo = returnArray.2 as? [String]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
        }
    }
    @IBAction func sdsViewBtnTapped(_ sender: Any) {
        //let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
        let vc = SDSView_VC()
        csicurrentSDS.sdsNo = csiclientsearchinfo.arrNo[rowNo]
        
        navigationController?.pushViewController(vc, animated: true)
        
        //self.navigationController?.pushViewController(sdsJump!, animated: true)
    }
    
}







extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return csiclientsearchinfo.arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        
        cell?.name.text = csiclientsearchinfo.arrName[indexPath.row]
        cell?.details.text = csiclientsearchinfo.arrDetail[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        rowNo = indexPath.row
        
    }
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    // swipe to delete the row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            csiclientsearchinfo.arrName.remove(at: indexPath.row)
            csiclientsearchinfo.arrDetail.remove(at: indexPath.row)
            csiclientsearchinfo.arrNo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}
