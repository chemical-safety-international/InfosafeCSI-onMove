//
//  Menu_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/6/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class Menu_VC: UIViewController {
    
    
    var buttonName = [" ", "Core Info.", "Classification", "First Aid", "Transport", "View SDS"]
    var buttonImage = ["menu-close-cross", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport", "CSI-ViewSDS"]
    
//    var buttonName = ["Core Info.", "Classification", "First Aid", "Transport", "View SDS"]
//    var buttonImage = ["CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport", "CSI-ViewSDS"]

    @IBOutlet weak var upImg: UIImageView!
    @IBOutlet weak var downImg: UIImageView!
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        menuTable.separatorStyle = .none
        self.view.backgroundColor = UIColor.clear
        upImg.layer.cornerRadius = 5
        downImg.layer.cornerRadius = 5
        menuTable.layer.cornerRadius = 5
//        upImg.isHidden = true
//        downImg.isHidden = true


        // Do any additional setup after loading the view.
        menuTable.reloadData()
        
        upImg.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func menuFunction(index: Int) {
        if buttonName[index] == "View SDS" {
            let sdsJump = storyboard?.instantiateViewController(withIdentifier: "SDSView") as? SDSView_VC
            self.navigationController?.pushViewController(sdsJump!, animated: true)
        }
        
        if buttonName[index] == " " {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        }
    }
    

}


extension Menu_VC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buttonName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if buttonName[indexPath.row] == " " {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuTableViewCell
            
            cell?.btnLbl.text = buttonName[indexPath.row]
            cell?.btnImg.image = UIImage(named: buttonImage[indexPath.row])
            let rect = CGRect.init(x: 30, y: 10, width: 30, height: 30)
            cell?.btnImg.draw(rect)
            
//            cell?.btnLbl.textColor = UIColor.white
            cell?.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuTableViewCell
        
        cell?.btnLbl.text = buttonName[indexPath.row]
        cell?.btnImg.image = UIImage(named: buttonImage[indexPath.row])
        cell?.btnLbl.textColor = UIColor.white
        cell?.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        menuFunction(index: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return downImg
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return upImg
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let minOffset: CGFloat = 0.0
        
        if (maxOffset - currentOffset <= 100.0) {
            downImg.isHidden = true
            upImg.isHidden = false
        } else if (currentOffset - minOffset <= 10.0) {
            downImg.isHidden = false
            upImg.isHidden = true
        }
    }
    
}
