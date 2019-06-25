//
//  Menu_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/6/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class Menu_VC: UIViewController {
    
    
//    var buttonName = [" ", "Core Info.", "Classification", "First Aid", "Transport", "View SDS"]
//    var buttonImage = ["menu-close-cross", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport", "CSI-ViewSDS"]
    
    var buttonName = ["View SDS", "Core Info.", "Classification", "First Aid", "Transport"]
    var buttonImage = ["CSI-ViewSDS", "CSI-Core", "CSI-Class", "CSI-Aid", "CSI-Transport"]

    @IBOutlet weak var upImg: UIImageView!
    @IBOutlet weak var downImg: UIImageView!
    @IBOutlet weak var menuTable: UITableView!

    
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        menuTable.separatorStyle = .none
        self.view.backgroundColor = UIColor.clear

//        menuTable.layer.cornerRadius = 5

        closeBtn.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
//        upImg.layer.cornerRadius = 5
//        downImg.layer.cornerRadius = 5
//        upImg.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
//        downImg.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
//        closeBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        menuTable.reloadData()
        
        upImg.isHidden = true
        
        if (menuTable.contentSize.height >= 250) {
            downImg.isHidden = true
        }
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
        
//        if buttonName[index] == " " {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
//        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuTableViewCell
        
//        if buttonName[indexPath.row] == " " {

            
//            cell?.btnLbl.text = buttonName[indexPath.row]
//            cell?.btnImg.image = UIImage(named: buttonImage[indexPath.row])
//            let rect = CGRect.init(x: 30, y: 10, width: 30, height: 30)
//            cell?.btnImg.draw(rect)
//
////            cell?.btnLbl.textColor = UIColor.white
//            cell?.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuTableViewCell
            
            cell?.btnLbl.text = buttonName[indexPath.row]
            cell?.btnImg.image = UIImage(named: buttonImage[indexPath.row])
            cell?.btnLbl.textColor = UIColor.white
            cell?.backgroundColor = UIColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 0.7)
//        }
    

        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        menuFunction(index: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return downImg
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return closeBtn
//    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (scrollView.contentOffset.y <= 20) {
            downImg.isHidden = false
            upImg.isHidden = true
        } else if scrollView.contentOffset.y >= maxOffset - 20 {
            downImg.isHidden = true
            upImg.isHidden = false
        }

    }
    
}
