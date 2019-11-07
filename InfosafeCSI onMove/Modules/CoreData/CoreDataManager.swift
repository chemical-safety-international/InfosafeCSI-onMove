//
//  CoreDataManager.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 20/8/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
//    static var realDelegate: AppDelegate?
//
//    static var appDelegate: AppDelegate {
//        if Thread.isMainThread {
//            return UIApplication.shared.delegate as! AppDelegate
//        }
//
//        let dg = DispatchGroup()
//        dg.enter()
//        DispatchQueue.main.async {
//            realDelegate = UIApplication.shared.delegate as? AppDelegate
//            dg.leave()
//        }
//        dg.wait()
//        return realDelegate!
//    }
    
    private class func getContext() -> NSManagedObjectContext {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        return appDelegate.persistentContainer.viewContext
    }
    
    //load data into coredata function
    class func storeObj(prodname: String, sdsno: String, company: String, issueDate: String, prodtype: String, unno: String, haz: String, dgclass: String, prodcode: String, ps: String, GHS_Pictogram: String, Com_Country: String) {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "SearchData", in: context)
        
        let manageObj = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObj.setValue(prodname, forKey: "prodname")
        manageObj.setValue(sdsno, forKey: "sdsno")
        manageObj.setValue(company, forKey: "company")
        manageObj.setValue(issueDate, forKey: "issueDate")
        manageObj.setValue(prodtype, forKey: "prodtype")
        manageObj.setValue(unno, forKey: "unno")
        manageObj.setValue(haz, forKey: "haz")
        manageObj.setValue(dgclass, forKey: "dgclass")
        manageObj.setValue(prodcode, forKey: "prodcode")
        manageObj.setValue(ps, forKey: "ps")
        manageObj.setValue(GHS_Pictogram, forKey: "ghs_Pictogram")
        manageObj.setValue(Com_Country, forKey: "com_Country")
        
        do {            
            try context.save()
            print("Saved successfully!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // fetch the objects from core data (if 'selectedScopeIndex: Int? = nil' means this fetch will return all data)
    class func fetchObj(targetText: String? = nil) -> [localSearchData] {
        
        var productArray = [localSearchData]()
        
        let fetchRequest: NSFetchRequest<SearchData> = SearchData.fetchRequest()
        
        if targetText != nil {
            var filterKeyword = ""
            filterKeyword = "prodname"
            
            let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", targetText!)
            fetchRequest.predicate = predicate
        }

        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                let prod = localSearchData(company: item.company!, issueDate: item.issueDate!, prodcode: item.prodcode!, prodname: item.prodname!, prodtype: item.prodtype!, ps: item.ps!, unno: item.unno!, dgclass: item.dgclass!, haz: item.haz!, GHS_Pictogram: item.ghs_Pictogram!, Com_Country: item.com_Country!)
                productArray.append(prod)
                }
            } catch {
                print(error.localizedDescription)
            }
        
            return productArray
        }
    
    
    class func storePDF(sdsno: String, pdfdata: String){
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "PDF", in: context)
        
        let manageObj = NSManagedObject(entity: entity!, insertInto: context)
        
        let pdfArray = CoreDataManager.fetchPDF(targetText: localcurrentSDS.sdsNo)
        
        if pdfArray.isEmpty == false {
            print("it already exist in core data")
        } else {
            manageObj.setValue(sdsno, forKey: "sdsno")
            manageObj.setValue(pdfdata, forKey: "pdfdata")
            
            do {
                try context.save()
                print("Saved successfully!")
            } catch {
                print(error.localizedDescription)
            }
        }

    }
    
    
    class func storePDFTest(sdsno: String, pdfdata: String){
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "PDF", in: context)
        
        let manageObj = NSManagedObject(entity: entity!, insertInto: context)
        
        

            manageObj.setValue(sdsno, forKey: "sdsno")
            manageObj.setValue(pdfdata, forKey: "pdfdata")
            
            do {
                try context.save()
                print("Saved successfully!")
            } catch {
                print(error.localizedDescription)
            }
        
        
    }
    
    
    class func fetchPDF(targetText: String? = nil) -> [localPDF] {
        
        var pdfArray = [localPDF]()
        
        let fetchRequest: NSFetchRequest<PDF> = PDF.fetchRequest()
        
        if targetText != nil {
            var filterKeyword = ""
            filterKeyword = "sdsno"

            let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", targetText!)
            fetchRequest.predicate = predicate
        }
        
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                let prod = localPDF(sdsno: item.sdsno!, pdfdata: item.pdfdata!)
                pdfArray.append(prod)
            }
        } catch {
            print(error.localizedDescription)
        }
        return pdfArray
    }

    
    class func cleanSearchCoreData() {
        
        let fetchRequest: NSFetchRequest<SearchData> = SearchData.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("Deleting all data!")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
//    class func deleteData(_ entity: String) {
//       let appdel = UIApplication.shared.delegate as! AppDelegate
//       let context = appdel.persistentContainer.viewContext
//
//        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PDF")
//        let deleteRequest = NSBatchDeleteResult(fetchRequest: deleteFetch)
//
//        do
//    }
    
    class func cleanPDFCoreData() {
        
        let fetchRequest: NSFetchRequest<PDF> = PDF.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("Deleting all data!")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
//    class func cleanTempData() {
//        do {
//            let content = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
//            for path in content {
//                let filep = URL(
//            }
//
//            for path in content {
//                let fullPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
//                try FileManager.default.removeItem(at: fullPath!)
//            }
//
//        } catch {
//            print(error.localizedDescription)
//        }
//
//    }
    
    class func appSize() {
        var fileSize: UInt64 = 0
        var budleSize: UInt64 = 0
        var docSize: UInt64 = 0
        var libSize: UInt64 = 0
        var tempSize: UInt64 = 0
        
        //go through the app's bundle
        do {
            let bundlePath = Bundle.main.bundlePath as NSString
            let bundleArray: NSArray = try FileManager.default.subpathsOfDirectory(atPath: bundlePath as String) as NSArray
            let bundleEnumerator = bundleArray.objectEnumerator()
            
            while let fileName:String = bundleEnumerator.nextObject() as? String {
                let fileDictionary: NSDictionary = try FileManager.default.attributesOfItem(atPath: bundlePath.appendingPathComponent(fileName)) as NSDictionary
                fileSize += fileDictionary.fileSize()
            }
            budleSize = fileSize
            print("budle size \(budleSize)\n")
        } catch {
            print(error.localizedDescription)
        }
        
        //GO through the app's document directory
        do {
            let documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true) as NSArray
            let documentDirectoryPath: NSString = documentDirectory[0] as! NSString
            let documentDirectoryArray:NSArray = try FileManager.default.subpathsOfDirectory(atPath: documentDirectoryPath as String) as NSArray
            let documentDirectoryEnumerator = documentDirectoryArray.objectEnumerator()
            
            while let file:String = documentDirectoryEnumerator.nextObject() as? String {
                let attributes: NSDictionary = try FileManager.default.attributesOfItem(atPath: documentDirectoryPath.appendingPathComponent(file)) as NSDictionary
                fileSize += attributes.fileSize()
            }
            docSize = fileSize - budleSize
            print("document size \(docSize)\n")
            
        } catch {
            print(error.localizedDescription)
        }
        
        //go through the app's library directory
        do {
            let libraryDirectory: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, .userDomainMask, true) as NSArray
            let libraryDirectoryPath: NSString = libraryDirectory[0] as! NSString
            let libraryDirectoryArray:NSArray = try FileManager.default.subpathsOfDirectory(atPath: libraryDirectoryPath as String) as NSArray
            let libraryDirectoryEnumerator = libraryDirectoryArray.objectEnumerator()
            
            while let file:String = libraryDirectoryEnumerator.nextObject() as? String {
                let attributes: NSDictionary = try FileManager.default.attributesOfItem(atPath: libraryDirectoryPath.appendingPathComponent(file)) as NSDictionary
                fileSize += attributes.fileSize()
            }
            libSize = fileSize - budleSize - docSize
            print("Library size \(libSize)\n")
            
        } catch {
            print(error.localizedDescription)
        }
        
        //go through the app's temp directory
        do {

            let tempDirectoryPath: NSString = NSTemporaryDirectory() as NSString
            let tempDirectoryArray:NSArray = try FileManager.default.subpathsOfDirectory(atPath: tempDirectoryPath as String) as NSArray
            let tempDirectoryEnumerator = tempDirectoryArray.objectEnumerator()
            
            while let file:String = tempDirectoryEnumerator.nextObject() as? String {
                let attributes: NSDictionary = try FileManager.default.attributesOfItem(atPath: tempDirectoryPath.appendingPathComponent(file)) as NSDictionary
                fileSize += attributes.fileSize()
            }
            tempSize = fileSize - budleSize - docSize - libSize
            print("Temp size \(tempSize)\n")
            
        } catch {
            print(error.localizedDescription)
        }
        
        let fileSystemSizeInMegaBytes: Double = Double(fileSize)/1000000
        print("Total App space: \(fileSystemSizeInMegaBytes)MB")
        
    }
    
    
}
