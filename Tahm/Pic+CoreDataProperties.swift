//
//  Pic+CoreDataProperties.swift
//  
//
//  Created by Chace on 2019/8/19.
//
//

import Foundation
import CoreData


extension Pic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pic> {
        return NSFetchRequest<Pic>(entityName: "Pic")
    }

    @NSManaged public var originalName: String?
    @NSManaged public var storage: String?
    @NSManaged public var uploadTime: NSDate?
    @NSManaged public var url: String?

}
