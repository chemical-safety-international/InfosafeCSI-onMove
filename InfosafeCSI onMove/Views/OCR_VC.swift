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

class OCR_VC: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var recognizeTextView: UITextView!
    @IBOutlet weak var cameraView: UIImageView!
    
    var imagePickerController: UIImagePickerController!
    
    var captureImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        }
        
    
    func recognizeImage(image: UIImage) {
        // Do any additional setup after loading the view.
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            
            tesseract.delegate = self
//            tesseract.image = UIImage(named: "testimage3")?.g8_blackAndWhite() as! UIImage
            tesseract.image = image
            tesseract.recognize()
            recognizeTextView.text = tesseract.recognizedText
            print(tesseract.recognizedText)
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
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        present(imagePickerController, animated: true, completion:  nil)
    }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePickerController.dismiss(animated: true, completion: nil)
            
//            cameraView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    //        imageView.image = info[.originalImage] as? UIImage
            cameraView.image = info[.originalImage] as? UIImage
            
            
            
            captureImage = cameraView.image
            let scaledImage = captureImage.scaledImage(1000)
            recognizeImage(image: scaledImage!)
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
}
