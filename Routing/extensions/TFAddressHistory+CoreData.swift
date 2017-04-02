//
//  TFAddressHistory+CoreData.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import Foundation

extension TFAddressHistory {
    
    func updateWithAddress(address: TFAddress) {
        self.fullAddress = address.fullAddress
        self.latitude = address.coordinates!.latitude
        self.longitude = address.coordinates!.longitude
    }
}
