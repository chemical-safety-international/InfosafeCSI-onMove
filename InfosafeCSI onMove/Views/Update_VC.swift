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
    @IBOutlet weak var strBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var showInfo: UIButton!
    
    let progress = Progress(totalUnitCount: 10)
    
    //new
    var isRed = false
    var progressBarTimer: Timer!
    var isRunning = false
    
    //test
    var isStop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        progressView.progress = 0.0
        startLoading()
    }
    
    @IBAction func stratBtnTapped(_ sender: Any) {
        //old
//        progressView.progress = 0.0
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
//
//            guard self.progress.isFinished == false else {
//                timer.invalidate()
////                print("Finished.")
//                return
//            }
//
//            self.progress.completedUnitCount += 1
//
//            let progressFloat = Float(self.progress.fractionCompleted)
//            self.progressView.setProgress(progressFloat, animated: true)
//
////            self.progressView.progress = progressFloat
        
//        }
        
        //new
        
        if(isRunning) {
            progressBarTimer.invalidate()
            strBtn.setTitle("Start", for: .normal)
        } else {
            strBtn.setTitle("Stop", for: .normal)
            progressView.progress = 0.0
            self.progressBarTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Update_VC.updateProgressView), userInfo: nil, repeats: true)
            
            if(isRed) {
                progressView.progressTintColor = UIColor.red
                progressView.progressViewStyle = .bar
                
            }
            isRed = !isRed
        }
        isRunning = !isRunning
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        progressView.progress = 1.0
        progressBarTimer.invalidate()
        isRunning = false
        strBtn.setTitle("Start", for: .normal)
        
    }
    @objc func updateProgressView() {
        
//        progressView.progress += 0.1
//        progressView.setProgress(progressView.progress, animated: true)
//        if(progressView.progress == 1.0)
//        {
//            progressBarTimer.invalidate()
//            isRunning = false
//            strBtn.setTitle("Start", for: .normal)
//        }
        
        if (isStop == false) {
            if (progressView.progress <= 0.8) {
                progressView.progress += 0.1
                progressView.setProgress(progressView.progress, animated: true)
            }
        }
        if (isStop == true) {
            progressView.progress = 1.0
            progressBarTimer.invalidate()
            isRunning = false
            strBtn.setTitle("Start", for: .normal)
        }
    }
    
    
    func startLoading() {
        progressView.progress = 0.0
          self.progressBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Update_VC.updateProgressView), userInfo: nil, repeats: true)
        
        let rtype : String = "1"
        csiWCF_VM().callSDS(sdsno: "MTF9H", rtype : rtype) { (completionReturnData) in
            DispatchQueue.main.async {

                if rtype == "1" {

                    let decodeData = Data(base64Encoded: completionReturnData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)

                    localcurrentSDS.pdfData = decodeData
                    print("finished loading")
                    self.isStop = true
                }

            }
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
