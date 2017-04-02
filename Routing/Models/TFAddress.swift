//
//  TFAddress.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import UIKit
import CoreLocation

@objc(TFAddress)

class TFAddress: NSObject {
    var fullAddress: String?
    var coordinates: CLLocationCoordinate2D?
    
    init(fullAddress: String) {
        super.init()
        self.fullAddress = fullAddress
    }
    
    init(address: String, coordinates: CLLocationCoordinate2D) {
        super.init()
        self.fullAddress = address
        self.coordinates = coordinates
    }
    
    func coordinatesText() -> String {
        if let latitude = self.coordinates?.latitude, let longitude = self.coordinates?.longitude {
            return "\(latitude), \(longitude)"
        }
        
        return ""
    }
}
