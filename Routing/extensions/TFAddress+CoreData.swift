//
//  TFAddress+CoreData.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import Foundation
import CoreLocation

extension TFAddress {
    
    convenience init(addressHistory: TFAddressHistory) {
        self.init(fullAddress: addressHistory.fullAddress!)
        self.coordinates = CLLocationCoordinate2DMake(addressHistory.latitude, addressHistory.longitude)
    }
}
