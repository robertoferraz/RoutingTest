//
//  TFGeolocationManager.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import UIKit
import MapKit

class TFGeolocationManager: NSObject {
    
    var searchResult = [TFAddress]()
    
    internal let kSearchDelayTime = 0.5
    internal let kMinCharacterSearch = 5
    internal var localSearch: MKLocalSearch?
    
    // This delay and invalidation is to avoid sending too many
    // requests when the user typing fast
    internal var searchTimer: Timer? {
        willSet {
            searchTimer?.invalidate()
        }
    }
    
    internal func addressFromPlacemark(placeMark: MKPlacemark) -> String {
        var addressParts = [String]()
        
        if let name = placeMark.name {
            addressParts.append(name)
        }
        
        if let thoroughfare = placeMark.thoroughfare {
            addressParts.append(thoroughfare)
        }
        
        if let subThoroughfare = placeMark.subThoroughfare {
            addressParts.append(subThoroughfare)
        }
        
        if let locality = placeMark.locality {
            addressParts.append(locality)
        }
        
        if let subLocality = placeMark.subLocality {
            addressParts.append(subLocality)
        }
        
        if let postalCode = placeMark.postalCode {
            addressParts.append(postalCode)
        }
        
        return addressParts.joined(separator: ", ")
    }
    
    internal func addressesFromSearchResponse(searchResponse: MKLocalSearchResponse) -> [TFAddress] {
        
        var addresses = [TFAddress]()
        
        for mapItem in searchResponse.mapItems {
            let placemark = mapItem.placemark
            
            if let addressString = placemark.addressDictionary!["FormattedAddressLines"] as? NSArray {
                
                let address = TFAddress(address: addressString.componentsJoined(by: ", "), coordinates: placemark.coordinate)
                addresses.append(address)
            }
            else {
                let address = TFAddress(address: self.addressFromPlacemark(placeMark: placemark), coordinates: placemark.coordinate)
                addresses.append(address)
            }
        }
        
        return addresses
    }
    
    func localSearchForAddress(address: String, success:@escaping() -> Void, failure:@escaping (Error) -> Void) {
        
        if address.characters.count < kMinCharacterSearch {
            return
        }
        
        self.searchTimer = Timer.scheduledTimer(timeInterval: kSearchDelayTime, target: BlockOperation.init(block: {
            
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = address
            
            // IMPORTANT:
            // For this simple application I didn't want to ask for the user location to keep it fast
            // with the user location I would need to handle user authorization, errors, etc
            // So I hardcoded Berlin as search region
            localSearchRequest.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(52.519361, 13.405094), span: MKCoordinateSpanMake(0.3, 0.3))
            
            self.localSearch?.cancel() // Cancel any request that was already sent
            self.localSearch = MKLocalSearch(request: localSearchRequest)
            
            self.localSearch!.start { (localSearchResponse, error) in
                guard error == nil else {
                    failure(error!)
                    return
                }
                
                self.searchResult = self.addressesFromSearchResponse(searchResponse: localSearchResponse!)
                success()
            }
            
        }), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
}
