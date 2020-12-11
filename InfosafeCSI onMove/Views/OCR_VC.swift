//
//  OCR_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 19/6/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit
import TesseractOCR
import MobileCoreServices
import GPUImage
import Mantis

class OCR_VC: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var retakePhotoButton: UIButton!
    @IBOutlet weak var OCRSearchButton: UIButton!
    
    @IBOutlet weak var recognizedTextView: UITextView!
    
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var imagePickerController: UIImagePickerController!
    
    var captureImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setRetakePhotoButton()
        hideKeyboard()
        takePhoto()

        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //Notify to disKeyboard
    @objc func disKeyboard() {
        recognizedTextView.endEditing(true)

    }
    
    //set up navigation bar
    func setNavBar() {

            self.navigationController?.navigationBar.isTranslucent = false
            self.view.backgroundColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white

            //change navigation bar text color and font
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
            self.navigationItem.title = "SCANNING OCR"

    }
    
    func setRetakePhotoButton() {
        retakePhotoButton.layer.cornerRadius = 10
        OCRSearchButton.layer.cornerRadius = 10
    }
        
    
    func recognizeImage(image: UIImage) {
        // Do any additional setup after loading the view.
        
//        self.showSpinner(onView: self.loadingScreen)
        
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            tesseract.charWhitelist = "abcdefghilmnopqrstuvzABCDEFGHILMNOPQRSTUVZ01234567890"
//            tesseract.charBlacklist = "~!@#$%^&*()`-_{}[]|;,.?/"
            
            tesseract.delegate = self
//            tesseract.image = UIImage(named: "testimage3")?.g8_blackAndWhite() as! UIImage
            tesseract.image = image
            tesseract.recognize()
            let recoText = tesseract.recognizedText?.trimmingCharacters(in: .whitespacesAndNewlines)
            if recoText!.isEmpty {
                recognizedTextView.text = "No text recognised."
            } else {
               recognizedTextView.text = recoText
            }
            
//            print(tesseract.recognizedText)
//            self.removeSpinner()
            loadingScreen.isHidden = true
        }
    }

    
    func progressImageRecognition(for tesseract: G8Tesseract) {
        print("Recognition Progress \(tesseract.progress) %")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        takePhoto()
    }
    
    
    func takePhoto() {
        
        loadingScreen.isHidden = false
        loadingLabel.text = "Loading..."
        imagePickerController = UIImagePickerController()
//        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
//        imagePickerController.mediaTypes = [kUTTypeImage as String]
        present(imagePickerController, animated: false, completion:  nil)
    }
    
//    func changeImageColorToBlackAndWhite(image: UIImage) -> UIImage {
//        let currentCGImage = image.cgImage
//        let currentCIImage = CIImage(cgImage: currentCGImage!)
//
//        let filter = CIFilter(name: "CIColorMonochrome")
//        filter?.setValue(currentCIImage, forKey: "inputImage")
//
//        // set a gray value for the tint color
//        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
//
//        filter?.setValue(1.0, forKey: "inputIntensity")
//        let outputImage = filter?.outputImage
//
//        let context = CIContext()
//
//        if let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent) {
//            let processedImage = UIImage(cgImage: cgimg)
//            print(processedImage.size)
//            return processedImage
//        } else {
//            return image
//        }
//    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePickerController.dismiss(animated: false, completion: nil)
        
//            cameraView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        imageView.image = info[.originalImage] as? UIImage
        
        
        
        if (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil
        {
            cameraView.image = info[.editedImage] as? UIImage

        }
        else if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
        {
            cameraView.image = info[.originalImage] as? UIImage
        }
        
        captureImage = cameraView.image
        
        if captureImage != nil {
            
            editPhoto(cameraImage: captureImage)
        }
        
//        let scaledImage = captureImage.scaledImage(1000)
//        let preprocessImage = scaledImage?.preprocessedImage() ?? scaledImage
//        recognizeImage(image: preprocessImage!)
        
//        let blackAndWhiteImage = changeImageColorToBlackAndWhite(image: preprocessImage!)
//        recognizeImage(image: blackAndWhiteImage)
    }
    
    @IBAction func OCRSearchButtonTapped(_ sender: Any) {
        
        let recognizeText = recognizedTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(recognizeText)
        if recognizedTextView.text!.isEmpty || recognizedTextView.text! == "No text recognised." || recognizedTextView.text! == "Recognising Text" {
            self.removeSpinner()
            recognizedTextView.text = ""
            
            self.showAlert(title:"", message: "Search content is empty.")
        } else {
//            self.recognizedTextView.endEditing(true)
            self.showSpinner(onView: self.view)
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            
            csiWCF_VM().callSearch(pnameInputData: recognizeText, supInputData: "", pcodeInputData: "", barcode: "", session: session) { (completionReturnData) in
                if completionReturnData == true {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        if searchTypeOption.searchType == "Product Search" {
                            let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "TablePage") as? SearchTablePage_VC
                            self.navigationController?.pushViewController(searchJump!, animated: true)
                        } else if searchTypeOption.searchType == "Check Before You Buy" {
                            let searchJump = self.storyboard?.instantiateViewController(withIdentifier: "CollectionTablePage") as? CheckpurchaseSearchMainPage_VC
                            self.navigationController?.pushViewController(searchJump!, animated: true)
                        }
  
                    }
                } else {
                    DispatchQueue.main.async {
                                self.removeSpinner()
                                self.showAlert(title: "", message: "No Search Results Found.")
                    }
                }
            }
        }
    }
    
    
}

extension UIImage {
  // 2
  func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
    // 3
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)
    // 4
    if size.width > size.height {
      scaledSize.height = size.height / size.width * scaledSize.width
    } else {
      scaledSize.width = size.width / size.height * scaledSize.height
    }
    // 5
    UIGraphicsBeginImageContext(scaledSize)
    draw(in: CGRect(origin: .zero, size: scaledSize))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    // 6
    return scaledImage
  }
    
    func preprocessedImage() -> UIImage? {
      // 1
      let stillImageFilter = GPUImageAdaptiveThresholdFilter()
      // 2
      stillImageFilter.blurRadiusInPixels = 15.0
      // 3
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
      // 4
      return filteredImage
    }
}

extension OCR_VC : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}

extension OCR_VC: CropViewControllerDelegate {
    func editPhoto(cameraImage: UIImage) {
        
        
        let cropViewController = Mantis.cropViewController(image: cameraImage)
        cropViewController.mode = .normal
        cropViewController.delegate = self
        
//        cropViewController.isModalInPresentation = true
        cropViewController.modalPresentationStyle = .fullScreen
//        self.isModalInPresentation = false
            
        present(cropViewController, animated: false, completion: nil)
        
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage) {
//        let scaledImage = captureImage.scaledImage(1000)
//        let preprocessImage = scaledImage?.preprocessedImage() ?? scaledImage
//        self.showSpinner(onView: cropViewController.view)
        
        cameraView.image = cropped
        
        recognizeImage(image: cropped)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
//        loadingScreen.isHidden = false
//        cameraView.image = original
//        recognizeImage(image: original)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    
}

public protocol CropViewControllerProtocal: class {
    func didGetCroppedImage(image: UIImage)
}
