//
//  TFAddressHistory+CoreDataProperties.swift
//  
//
//  Created by Roberto Ferraz on 02/04/2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TFAddressHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TFAddressHistory> {
        return NSFetchRequest<TFAddressHistory>(entityName: "TFAddressHistory");
    }

    @NSManaged public var fullAddress: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
