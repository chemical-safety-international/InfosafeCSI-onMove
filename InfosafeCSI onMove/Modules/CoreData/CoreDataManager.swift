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
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //load data into coredata function
    class func storeObj(prodname: String, sdsno: String, company: String, issueDate: String, prodtype: String, unno: String, haz: String, dgclass: String, prodcode: String, ps: String) {
        
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
                let prod = localSearchData(company: item.company!, issueDate: item.issueDate!, prodcode: item.prodcode!, prodname: item.prodname!, prodtype: item.prodtype!, ps: item.ps!, unno: item.unno!, dgclass: item.dgclass!, haz: item.haz!)
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

    
    class func cleanCoreData() {
        
        let fetchRequest: NSFetchRequest<SearchData> = SearchData.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("Deleting all data!")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
    
    
    
    }

