//
//  TFDatabaseHandler.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import UIKit
import MagicalRecord

class TFDatabaseHandler: NSObject {

    static let sharedInstance = TFDatabaseHandler()
    
    func setupDatabase() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "TFHistory")
    }
    
    func saveSearchedAddress(address: TFAddress) {
        
        let savedHistory = TFAddressHistory.mr_findAll(with: NSPredicate(format: "fullAddress = %@ AND latitude = %f  AND longitude = %f", argumentArray: [address.fullAddress ?? "", address.coordinates!.latitude, address.coordinates!.longitude]))
        
        if let history = savedHistory, history.count > 0 {
            return
        }
        
        MagicalRecord.save({ (localContext) in
            let addressHistory = TFAddressHistory.mr_createEntity(in: localContext)
            addressHistory?.updateWithAddress(address: address)
        })
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    func searchedAddresses() -> [TFAddress] {
        var addresses = [TFAddress]()
        
        for addressHistory in TFAddressHistory.mr_findAll() as! [TFAddressHistory] {
            addresses.append(TFAddress(addressHistory: addressHistory))   
        }
        
        return addresses
    }
}
