//
//  Coredata+Extensions.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import CoreData

extension NSManagedObject {
    class func entityDescription() -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName(), in: CoredataContext.managedObjectContext)!
    }
    
    static func entityName() -> String {
        let fullClassName: String = NSStringFromClass(object_getClass(self)!)
        let classNameComponents: [String] = fullClassName.components(separatedBy: ".")
        return classNameComponents.last!
    }
}
