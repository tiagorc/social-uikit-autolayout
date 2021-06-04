//
//  BaseCoreDataObject.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import Foundation
import CoreData

enum CacheTime : Int {
    case d1 = 1
    case h8 = 8
    case m15 = 15
    case s600 = 600 ///equivalente a 10 minutos (por o enum já possuir a chave d10 = 10) houve essa mudanca no valor
    
    var calendarComponent: Calendar.Component  {
        switch self {
        case  .d1:
            return .day
        case .h8:
            return .hour
        case .s600:
            return .second
        default:
            return .minute
        }
    }
}

class BaseCoreDataObject: NSManagedObject {
    
    // Cache constraints
    @NSManaged var data: Data?
    @NSManaged var primaryKey: String?
    @NSManaged var expirationDate: String?
    
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

typealias CacheObject = CacheProtocol & Codable

protocol CacheProtocol {
    static var className: String { get }
    var className: String { get }
}

extension CacheProtocol where Self: CacheObject {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    static func saveInCache(primaryKey: String, cacheObject: Self?, expirationTime: CacheTime = .m15) {

        let object = BaseCoreDataObject(entity: BaseCoreDataObject.entityDescription(), insertInto: CoredataContext.managedObjectContext)
        
        
        object.expirationDate = String.dateToStringByAddingMinutes(date: Date(), amountOfMinutes: expirationTime.rawValue, calendarComponent: expirationTime.calendarComponent)
        
        do {
            if let result = cacheObject {
                object.primaryKey = "\(result.className):\(primaryKey)"
                let json = try? JSONEncoder().encode(result)
                object.data = json
            } else {
                object.primaryKey = primaryKey
                object.data = nil
            }
            
            CoredataContext.saveContext()
            
        } catch {
            debugPrint("Cannot parse or save \(BaseCoreDataObject.entityName()) object!")
        }
    }
    
    static func saveInCache(primaryKey: String, cacheObject: Self?, expirationTime: Int) {

        let object = BaseCoreDataObject(entity: BaseCoreDataObject.entityDescription(), insertInto: CoredataContext.managedObjectContext)
        
        object.primaryKey = primaryKey
        
        object.expirationDate = String.dateToStringByAddingMinutes(date: Date(), amountOfMinutes: expirationTime)
        
        do {
            if let result = cacheObject {
                object.primaryKey = "\(result.className):\(primaryKey)"
                let json = try? JSONEncoder().encode(result)
                object.data = json
            } else {
                object.primaryKey = primaryKey
                object.data = nil
            }
            
            CoredataContext.saveContext()
            
        } catch {
            debugPrint("Cannot parse or save \(BaseCoreDataObject.entityName()) object!")
        }
    }
    
    static func loadValidObject(primaryKey: String) -> Self? {
        

        let pk = "\(Self.className):\(primaryKey)"
        if let coreDataObject = retrieveFromCache(pk: pk) {
            
            var result: Self?
            
            if let dataObject = coreDataObject.data {
                result = try? JSONDecoder().decode(self, from: dataObject)
            }
            let isValid = isCacheValid(cacheObject: coreDataObject)
            
            if !isValid {
                deleteData(dataToDelete: [coreDataObject])
                return nil
            }
            return result
        } else {
            return nil
        }
    }
    
    static func loadAll(primaryKey: String) -> [Self]? {
        let pk = "\(Self.className):\(primaryKey)"
        
        if let records = retrieveAllFromCache(pk: pk) {
            var results: [Self]? = []
            records.forEach { record in
                var result: Self?
                
                if let dataObject = record.data {
                    result = try? JSONDecoder().decode(self, from: dataObject)
                }
                
                let isValid = isCacheValid(cacheObject: record)
                
                if isValid, let result = result as Self? {
                    results?.append(result)
                } else {
                    deleteData(dataToDelete: [record])
                }
            }
            return results
        } else {
            return nil
        }
    }
    
    static fileprivate func getRequest(pk: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: BaseCoreDataObject.entityName())
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "primaryKey = %@", pk)
            
        return request
    }
    
    static func retrieveFromCache(pk: String) -> BaseCoreDataObject? {
        let context = CoredataContext.managedObjectContext
        let request = getRequest(pk: pk)
        
        do {
            let results = try context.fetch(request) as? [NSManagedObject]
                return results?.first as? BaseCoreDataObject
        } catch let error as NSError {
            print("Could not retrieve", error, error.userInfo)
            return nil
        }
    }
    
    static func retrieveAllFromCache(pk: String) -> [BaseCoreDataObject]? {
        let context = CoredataContext.managedObjectContext
        let request = getRequest(pk: pk)
        
        do {
            let results = try context.fetch(request) as? [NSManagedObject]
                return results as? [BaseCoreDataObject]
        } catch let error as NSError {
            print("Could not retrieve", error, error.userInfo)
            return nil
        }
    }
    
    static func isCacheValid(cacheObject: BaseCoreDataObject?) -> Bool {
        let expDate = cacheObject?.expirationDate?.date(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        if let date = expDate, date > Date() {
            return true
        }
        
        return false
    }
    
    static func deleteData(dataToDelete: [BaseCoreDataObject]) {
        let context = CoredataContext.managedObjectContext
        BaseDAO().deleteExpiredData(results: dataToDelete, context: context)
    }
    
    static func expireCache(pk: String) {
        let request = getRequest(pk: pk)
        BaseDAO().expireCache(request: request)
    }
    
    static func getRequestAll() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: BaseCoreDataObject.entityName())
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "")
        
        return request
    }
    
    static func expireAllCache() {
        let request = getRequestAll()
        BaseDAO().expireCache(request: request)
    }
}

public class BaseDAO: NSObject {
    
    func deleteExpiredData(results: [NSManagedObject], context: NSManagedObjectContext) {
        for result in results {
            context.delete(result)
        }

        CoredataContext.saveContext()
    }
    
    func isCacheValid(expDateString: String) -> Bool {
       
        let expDate =  expDateString.date(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        if let date = expDate, date > Date() {
            return true
        }
        
        return false
    }
    
    func expireCache(request: NSFetchRequest<NSFetchRequestResult>) {
        let context = CoredataContext.managedObjectContext
        
        do {
            guard let objects = try context.fetch(request) as? [NSManagedObject] else { return }
            self.deleteExpiredData(results: objects, context: CoredataContext.managedObjectContext)

        } catch let error as NSError {
            print("Could not save updated data", error, error.userInfo)
        }
    }
    
    func saveErrorInCache(entityDescription: String, waitUntil: String, predicates: [String: Any]) {
        let context = CoredataContext.managedObjectContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityDescription, in: context) else {
            return
        }
        
        let objectToUpdate: NSManagedObject = NSManagedObject(entity: entity, insertInto: context)
        objectToUpdate.setValue(waitUntil, forKey: "experationDate")
        
        for (key, value) in predicates {
            objectToUpdate.setValue(value, forKey: key)
        }
        
        CoredataContext.saveContext()
    }
    
    func canMakeRequest(request: NSFetchRequest<NSFetchRequestResult>) -> Bool {
        let context = CoredataContext.managedObjectContext
        
        do {
            guard let results = try context.fetch(request) as? [NSManagedObject],
                let object = results.first,
                let waitUntilString = object.value(forKey: "experationDate") as? String,
                let waitUntilAsDate = waitUntilString.date(format: "yyyy-MM-dd'T'HH:mm:ssZ") else {
                    return true
            }
            
            if waitUntilAsDate >= Date() {
                return false
            }
        } catch let error as NSError {
            print("Could not retrieve", error, error.userInfo)
        }
        return true
        
    }
}
