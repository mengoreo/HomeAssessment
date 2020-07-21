//
//  SearchResultViewController.swift
//  tet
//
//  Created by Mengoreo on 2020/2/26.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import UIKit
import MapKit
import Contacts // calculate distance

class SearchResultViewController : UITableViewController {

    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var myLocatoin: MKUserLocation!
    
    var blurEffect: UIBlurEffect!
    var blurView: UIVisualEffectView!
    
    var loadingResults = false
    let loadingView = UIActivityIndicatorView(style: .medium)
    var lastSearched = ""
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
        setUpTableView()
    }
    
    // MARK: - setupBlurView
    func setupBlurView() {
        blurEffect = UIBlurEffect(style: .regular)
        blurView = UIVisualEffectView(effect: blurEffect)
    }
    
    // MARK: - setUpTableView
    func setUpTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.backgroundView = blurView
        tableView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        loadingView.topAnchor.constraint(equalToSystemSpacingBelow: tableView.topAnchor, multiplier: 1).isActive = true
        loadingView.isHidden = true
        
    }

    func startLoading() {
        tableView.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        loadingView.startAnimating()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func stopLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
        tableView.sendSubviewToBack(loadingView)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension SearchResultViewController {
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        cell.backgroundColor = .clear

        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.address()
        
        
        return cell
    }

}

// MARK: - UISearchResultsUpdating
extension SearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        let searchText = searchController.searchBar.text ?? ""
        if searchText != lastSearched,
            let mapView = mapView {
            
            lastSearched = searchText
            DispatchQueue.main.async {
                self.startLoading()
            }
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    print("*** no response")
                    
                    self.matchingItems.removeAll()
                    self.matchingItems.append(MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: [CNPostalAddressCityKey: "没有搜索到「\(searchText)」"])))
                    DispatchQueue.main.async {
                        self.stopLoading()
                    }
                    return
                }
                
                self.matchingItems = response.mapItems
                self.matchingItems.sort(by: {a, b in
                    return self.distanceTo(a.placemark) > self.distanceTo(b.placemark)
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("** ", self.matchingItems)
                    self.stopLoading()
                }
                
            }
        } else {
            // empty items
            if searchText.isEmpty {
                matchingItems.removeAll()
            }
            DispatchQueue.main.async {
                self.stopLoading()
            }
        }
        
    }
    
    private func distanceTo(_ place: MKPlacemark) -> CLLocationDistance {
        // only called when mapView is not nil
        return CLLocation(latitude: mapView!.userLocation.coordinate.latitude,
                          longitude: mapView!.userLocation.coordinate.longitude)
                        .distance(from: place.location!)
    }
}

