//
//  Scanner_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 21/5/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit
import AVFoundation

class Scanner_VC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var barcodeValue: String!
    @IBOutlet weak var captureView: UIView!
//    @IBOutlet weak var buttonView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buttonView.backgroundColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        startScan()
    }
    
    //set up navigation bar
        func setNavBar() {

            //change background color
//            DispatchQueue.main.async {

                //change background color & back button color
                self.navigationController?.navigationBar.isTranslucent = false
                self.view.backgroundColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
                self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
                self.navigationController?.navigationBar.tintColor = UIColor.white

                //change navigation bar text color and font
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
                self.navigationItem.title = "SCANNING"

                // set right item to make title view in the center
    //            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "    ", style: .plain, target: self, action: .none)
//                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//                self.navigationController?.navigationBar.shadowImage = UIImage()
//                self.navigationController?.navigationBar.layoutIfNeeded()
//
//            }
    }
    
    //build capture function and view
    func startScan() {
        
        captureView.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code128, .code39, .code93, .itf14, .qr, .code39Mod43, .aztec, .dataMatrix, .interleaved2of5, .upce]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = captureView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill

        captureView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        setNavBar()
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            barcodeValue = stringValue
            found(code: barcodeValue)
        }

//                dismiss(animated: true)
    }

    func found(code: String) {
//        print("code is: " + code)
        scanAlert()


    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //Alert after scanning
    func scanAlert() {
//        let ac = UIAlertController(title: "Barcode Detected", message: "Search the value:\n\"\(barcodeValue ?? "NULL")\"?", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
//            ac.dismiss(animated: true, completion: nil)
            
            self.showSpinner(onView: self.view)
            
            localsearchinfo.results = []
            
            //call search function
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            
            csiWCF_VM().callSearch(pnameInputData: "", supInputData: "", pcodeInputData: "", barcode: self.barcodeValue, session: session) { (completionReturnData) in
                            if completionReturnData == true {
                                DispatchQueue.main.async {
                                    self.removeSpinner()
                                    let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? SearchTablePage_VC
                                    self.navigationController?.pushViewController(searchJump!, animated: true)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.removeSpinner()
                                    self.showAlert(title: "", message: "No result found.")
                                    self.startScan()
                                }
                            }
            }
            //back to pervious page
//            _ = self.navigationController?.popViewController(animated: true)
//        }))
//        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) in
//            ac.dismiss(animated: true, completion: nil)
//
//            //redo the scanning
//            self.startScan()
//        }))
//        self.present(ac, animated: true, completion: nil)
    }
    
    //instead of navigation bar back button, back to pervious page
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}


extension Scanner_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
