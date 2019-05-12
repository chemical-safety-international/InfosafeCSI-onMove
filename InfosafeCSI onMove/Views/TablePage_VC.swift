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
    
    var arrName:[String] = []
    var arrDetail:[String] = []
    var arrNo:[String] = []
    
    var selectedIndex:Bool = false;
    var select = -1
    var rowNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
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
    self.tableDisplay.reloadData()
    }
    
    func beginSearch(loginData: (String,String,String), input: String) {
        csiWCF_GetSDSSearchResultsPageEx(clientid: loginData.0, clientmemberid: loginData.1, infosafeid: loginData.2, inputData: input) {
            (returnData) in
            
            if returnData.contains("false") {
                print("No data return from search")
            } else {
                let returnArray = csiWCF_SearchReturnValueFix(inValue: returnData)
                print("Success called search: \n \(returnArray.0)")
                
                self.arrName = returnArray.0 as! [String]
                self.arrDetail = returnArray.1 as! [String]
                self.arrNo = returnArray.2 as! [String]
                
                DispatchQueue.main.async {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawVaule: "load"), object: nil)
                    TablePage_VC().tableDisplay.reloadData()
                }
            }
        }
    }

}







extension TablePage_VC: UITableViewDelegate, UITableViewDataSource {
    // non-expandable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        
        cell?.name.text = arrName[indexPath.row]
        cell?.details.text = arrDetail[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        //            if (select == indexPath.row)
        //            {
        //                select = -1;
        //                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //                return
        //            }
        //            if (select == -1)
        //            {
        //                let prev = NSIndexPath(row:select, section: 0)
        //                select = indexPath.row
        //                tableView.reloadRows(at: [prev as IndexPath], with: UITableView.RowAnimation.automatic)
        //            }
        //            select = indexPath.row
        //            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
        rowNo = indexPath.row
        
    }
    
    // change the height to expand tableDisplay value
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //                    if (select == indexPath.row){
        return 170
        //                    }
        //                    else {
        //
        //                        return UITableView.automaticDimension
        //                    }
        
    }
    
    // swipe to delete the row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrName.remove(at: indexPath.row)
            arrDetail.remove(at: indexPath.row)
            arrNo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}
