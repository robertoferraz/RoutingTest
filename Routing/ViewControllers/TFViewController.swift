//
//  TFViewController.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import UIKit
import MapKit

class TFViewController: UIViewController, UISearchResultsUpdating, TFSearchResultDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var originSearchBarContainerView: UIView!
    @IBOutlet weak var destinationSearchBarContainerView: UIView!
    
    @IBOutlet weak var routeInformationView: UIView!
    @IBOutlet weak var routeDistanceLabel: UILabel!
    @IBOutlet weak var routeDurationLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let distanceFormatter = MKDistanceFormatter()
    var destinationAddress: TFAddress?
    var originAddress: TFAddress?
    
    let originSearchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TFSearchResultTableViewController"))
    
    let destinationSearchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TFSearchResultTableViewController"))
    
    //PRAGMA MARK: - ViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        self.originSearchController.searchResultsUpdater = self
        self.originSearchController.dimsBackgroundDuringPresentation = true
        
        self.destinationSearchController.searchResultsUpdater = self
        self.destinationSearchController.dimsBackgroundDuringPresentation = true
        
        originSearchController.searchBar.placeholder = "Origin address"
        destinationSearchController.searchBar.placeholder = "Destination address"
        
        self.originSearchBarContainerView.addSubview(originSearchController.searchBar)
        self.destinationSearchBarContainerView.addSubview(destinationSearchController.searchBar)
    }
    
    //PRAGMA MARK: - Helper functions
    
    internal func drawMapRoute(route: MKPolyline) {
        self.map.add(route)
        
        let rect = self.map.overlays.reduce(route.boundingMapRect, {MKMapRectUnion($0, $1.boundingMapRect)})
        self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0), animated: true)
    }
    
    internal func updateDestinationObjects() {
        if self.originSearchController.searchBar.text == "" {
            self.originAddress = nil
        }
        
        if self.destinationSearchController.searchBar.text == "" {
            self.destinationAddress = nil
        }
        
        if self.originAddress == nil || self.destinationAddress == nil {
            self.routeInformationView.isHidden = true
            self.map.removeOverlays(self.map.overlays)
        }
    }
    
    internal func showRouteInformationForRoute(route: MKRoute) {
        self.distanceFormatter.unitStyle = .abbreviated
        self.routeDistanceLabel.text = self.distanceFormatter.string(fromDistance: route.distance)
        self.routeDurationLabel.text = "\(round(route.expectedTravelTime/60)) minutes"
        self.routeInformationView.isHidden = false
    }
    
    internal func edittingSearchController() -> UISearchController {
        return self.originSearchController.searchBar.isFirstResponder ? self.originSearchController : self.destinationSearchController
    }
    
    //PRAGMA MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.isFirstResponder {
            searchController.searchResultsController?.view.isHidden = false
        }
        
        if let searchResultController = searchController.searchResultsController as? TFSearchResultTableViewController {
            searchResultController.delegate = self
            searchResultController.searchText = searchController.searchBar.text ?? ""
            
            if searchResultController.searchText == "" {
                self.updateDestinationObjects()
            }
        }
    }
    
    //PRAGMA MARK: - TFSearchResultDelegate
    
    func searchResultController(searchResultController: TFSearchResultTableViewController, didSelectAddress address: TFAddress) {
        
        self.map.removeOverlays(self.map.overlays)
        
        TFDatabaseHandler.sharedInstance.saveSearchedAddress(address: address)
        
        let searchController = self.edittingSearchController()
        
        searchController.searchBar.text = address.fullAddress
        self.dismiss(animated: true, completion: nil)
        
        if searchController == self.originSearchController {
            self.originAddress = address
        }
        else {
            self.destinationAddress = address
        }
        
        if let origin = self.originAddress, let destination = self.destinationAddress {
            TFRoutingManager.routeFrom(fromCoordinates: origin.coordinates!, toCoordinates: destination.coordinates!, transportType: .automobile, success: { (directions) in
                
                if let route = directions.routes.first {
                    self.drawMapRoute(route: route.polyline)
                    self.showRouteInformationForRoute(route: route)
                }
                
            }, failure: { (error) in
                let alertControl = UIAlertController(title: "Ops", message: "It wasnt possible to calculate the route, please try again later", preferredStyle: .alert)
                alertControl.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertControl, animated: true, completion: nil)
            })
        }
    }
    
    //PRAGMA MARK: - MKMapViewDelegate
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let routeView = MKPolylineRenderer(overlay: overlay)
        routeView.lineWidth = 5.0
        routeView.strokeColor = UIColor.green
        return routeView
    }
}


