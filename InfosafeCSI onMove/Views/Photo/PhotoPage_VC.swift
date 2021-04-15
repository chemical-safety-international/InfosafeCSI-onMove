//
//  PhotoPage_VC.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 15/7/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class PhotoPage_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func takePhotoBtnTapped(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion:  nil)
    }
    
    @IBAction func savePhotoBtnTapped(_ sender: Any) {
        //var photoNo = 0
        //var photoName = "\(photoNo).png"
        saveImage(imageName: "text.png")
        //present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    @IBAction func goToGalleryBtnTapped(_ sender: Any) {
//        performSegue(withIdentifier: "gallerySegue", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        imageView.image = info[.originalImage] as? UIImage
    }
    
    func saveImage(imageName: String) {
        //create an instance of the FileManager
        let fileManager = FileManager.default
        
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let imagePath = "\(paths)/\(imageName)"
        
//        let imagePath1 = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[1] as NSString).appendingPathComponent(imageName)
        
        //get the image we took with camera
        let image = imageView.image!
        
        //get the PNG data for this image
        let imageData = image.pngData()
        
        
//        print(imagePath)
//        print(imagePath1)
//        print("Binary data is: \(String(describing: imageData))")
        
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: imageData, attributes: nil)
        
        if fileManager.fileExists(atPath: imagePath) {
            showAlert(title: "", message: "Successed saved photo!")
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

}
