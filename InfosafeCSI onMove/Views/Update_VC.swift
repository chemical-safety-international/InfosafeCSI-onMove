//
//  Update_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 20/9/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit



class Update_VC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var showInfo: UIButton!
    
    let progress = Progress(totalUnitCount: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func stratBtnTapped(_ sender: Any) {
//        progressView.progress = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            guard self.progress.isFinished == false else {
                timer.invalidate()
//                print("Finished.")
                return
            }
            
            self.progress.completedUnitCount += 1
            
            let progressFloat = Float(self.progress.fractionCompleted)
            self.progressView.setProgress(progressFloat, animated: true)
            
//            self.progressView.progress = progressFloat
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
    
    @IBAction func showInfoTapped(_ sender: Any) {
        
//        print(UIDevice.current.modelName)
        deviceName()
        modelName()
        UUID()
        currentDate()
        currentDevice()

    }
    
    func modelName() {
        let modelName = UIDevice.modelName
        print("Model name: \(modelName)\n")
        
    }
    
    // for identify the device uniquely (will create a new one after reinstalling)
    func UUID() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        print("UUID: \(uuid ?? "")\n")
    }
    
    func deviceName() {
        let deviceName = UIDevice.current.name
        print("Device name: \(deviceName)\n")
        
    }
    
    func currentDate() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss dd-MM-yyyy"
        
        let formattedDate = format.string(from: date)
        print("Current date: \(formattedDate)\n")
    }
    
    func currentDevice() {
        
        print("Device systen name: \(UIDevice.current.systemName)\n")
        print("Device system version: \(UIDevice.current.systemVersion)\n")
    }
    
}
