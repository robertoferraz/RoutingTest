//
//  TFSearchResultTableViewController.swift
//  Routing
//
//  Created by Roberto Ferraz on 02/04/2017.
//  Copyright © 2017 Roberto Ferraz. All rights reserved.
//

import UIKit

protocol TFSearchResultDelegate: NSObjectProtocol {
    func searchResultController(searchResultController: TFSearchResultTableViewController, didSelectAddress address: TFAddress)
}

class TFSearchResultTableViewController: UITableViewController {
    
    internal let locationManager = TFGeolocationManager()
    weak var delegate: TFSearchResultDelegate?
    
    var searchText = "" {
        didSet {
            
            guard !searchText.isEmpty else { return }
            
            self.locationManager.localSearchForAddress(address: searchText, success: {
                self.tableView.reloadData()
            }) { (error) in
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.locationManager.searchResult.count : TFDatabaseHandler.sharedInstance.searchedAddresses().count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Search results" : "Saved searchs"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let address = (indexPath.section == 0) ? self.locationManager.searchResult[indexPath.row] : TFDatabaseHandler.sharedInstance.searchedAddresses()[indexPath.row]
        
        
        // For the sake of speed, I am setting the cell properties from the ViewController
        // I am particularly against it, because I think that view elements (label, textfields, etc)
        // Should always be private and thus not accessible from the ViewController
        // Normally I would create a CellModel object that holds the information the cell needs to display
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        cell.textLabel?.text = address.fullAddress
        cell.detailTextLabel?.text = address.coordinatesText()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let address = (indexPath.section == 0) ? self.locationManager.searchResult[indexPath.row] : TFDatabaseHandler.sharedInstance.searchedAddresses()[indexPath.row]
        self.delegate?.searchResultController(searchResultController: self, didSelectAddress: address)
    }
}
