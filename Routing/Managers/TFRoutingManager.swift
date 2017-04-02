//
//  TFRoutingManager.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import UIKit
import MapKit

class TFRoutingManager: NSObject {

    static func routeFrom(fromCoordinates: CLLocationCoordinate2D, toCoordinates: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, success:@escaping ((MKDirectionsResponse) -> Void), failure:@escaping ((Error) -> Void)) {
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: fromCoordinates))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: toCoordinates))
        directionRequest.transportType = transportType
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (directionResponse, error) in
            guard error == nil else {
                failure(error!)
                return
            }
            
            success(directionResponse!)
        }
    }
}
