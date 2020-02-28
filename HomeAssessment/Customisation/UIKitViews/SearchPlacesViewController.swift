//
//  SearchPlacesViewController.swift
//  tet
//
//  Created by Mengoreo on 2020/2/26.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import UIKit
import MapKit
import Combine

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class SearchPlacesViewController : UIViewController {
    
    var selectedPlace: MKPlacemark?
    var handleTapOnMapCallout: (_ selected:MKAnnotation) -> Void
    init(selectedPlace: MKPlacemark?,
         handleTapOnMapCallout: @escaping (_ selected: MKAnnotation) -> Void) {
        self.selectedPlace = selectedPlace
        self.handleTapOnMapCallout = handleTapOnMapCallout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var blurEffect: UIBlurEffect!
    var blurView: UIVisualEffectView!
    
    private var mapView: MKMapView!
    private var searchController: UISearchController!
    private let locationManager = CLLocationManager()
    private let mapSnapshotOptions = MKMapSnapshotter.Options()
    private let searchResultsController = SearchResultViewController()
    private struct SpanType {
        static let placeScale: CLLocationDegrees = 0.003
        static let countryScale: CLLocationDegrees = 70
    }
    private let geocoder = CLGeocoder()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
        setUpMapView()
        setUpLocationManager()
        setupSearchController()
        setupNavigationBar()
        
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
        locationManager.requestLocation()
        if let selected = selectedPlace {
            print("** drop on appear")
            dropPinZoomIn(placemark: selected)
        } else {
            focuseOnUserLocation()
        }
    }
    
    // MARK: - setupBlurView
    func setupBlurView() {
        blurEffect = UIBlurEffect(style: .regular)
        blurView = UIVisualEffectView(effect: blurEffect)
    }
    
    // MARK: -setUpMapView
    func setUpMapView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
    }
    
    // MARK: - setUpLocationManager
    func setUpLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .denied:
            print("authStatus: denied")
        case .notDetermined:
            print("authStatus: notDetermined")
        case .restricted:
            print("authStatus: restricted")
        default:
            break
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - setupSearchController
    func setupSearchController() {
        searchResultsController.mapView = mapView
        searchResultsController.handleMapSearchDelegate = self
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        searchController.searchResultsUpdater = searchResultsController
//        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "选择地址"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .darkGreen
        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    // MARK: - setupNavigationBar
    func setupNavigationBar() {
        navigationItem.title = "搜索位置"
        let standard = UINavigationBarAppearance()
             
        standard.configureWithOpaqueBackground()

        standard.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)
        standard.backgroundEffect = blurEffect
        navigationController?.navigationBar.standardAppearance = standard
        navigationController?.navigationBar.scrollEdgeAppearance = standard
        
        let focusButton = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(focuseOnUserLocation))
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        
        navigationItem.setRightBarButtonItems([focusButton], animated: true)
        navigationItem.setLeftBarButton(closeButton, animated: true)
        navigationController?.navigationBar.tintColor = .darkGreen
        navigationController?.modalPresentationStyle = .fullScreen
    }
    
    // MARK: - selectors
    @objc func showSearchBar() {
        searchController.isActive = true
    }
    @objc func hideSearchBar() {
        searchController.isActive = false
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func focuseOnUserLocation() {
        focusMap(on: mapView.userLocation.coordinate)
    }
    
    // MARK: - Helper
    private func focusMap(on coordinate: CLLocationCoordinate2D) {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: SpanType.placeScale, longitudeDelta: SpanType.placeScale)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)

        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - setupUserLocationCallout
    private func setupUserLocationCallout(for view: MKAnnotationView) {
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        rightButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .highlighted)        
        rightButton.tintColor = .darkGreen
        view.rightCalloutAccessoryView = rightButton // rightcallout is nil
        
    }
    
    // MARK: - setupPinCallout
    private func setupCustomPinCallout(for annotation: MKAnnotation) -> MKAnnotationView {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: String(describing: CustomAnnotation.self))
        annotationView.markerTintColor = .darkGreen
        annotationView.canShowCallout = true
        
        let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 23))
        detailLabel.text = annotation.subtitle ?? ""
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 0
        detailLabel.font = .preferredFont(forTextStyle: .footnote)
        detailLabel.textColor = .secondaryLabel
        annotationView.detailCalloutAccessoryView = detailLabel
        
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        rightButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .highlighted)
        rightButton.tintColor = .darkGreen

        annotationView.rightCalloutAccessoryView = rightButton
        return annotationView
    }
}

// MARK: - MKMapViewDelegate
extension SearchPlacesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("** mapView didUpdate userLocation")
//        if selectedPlace == nil {
//            focusMap(on: userLocation.coordinate)
//        } else {
//            focusMap(on: selectedPlace!.coordinate)
//        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("** mapView didSelect view")
        if view.annotation!.isKind(of: MKUserLocation.self) {
            print("** configure user")
            mapView.userLocation.title = "选择我现在的位置"
            setupUserLocationCallout(for: view)
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // customize in didselect .
            return nil
        }
        
        if let annotation = annotation as? CustomAnnotation {
            let view = setupCustomPinCallout(for: annotation)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                mapView.selectAnnotation(annotation, animated: true)
            }
            return view
        }
        return nil
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("** mapView calloutAccessoryControlTapped")
        handleTapOnMapCallout(view.annotation!)
        close()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension SearchPlacesViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("AuthorizationStatus:", status)
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("** didUpdateLocations")
        if let selectedPin = selectedPlace {
            // show cached results
            dropPinZoomIn(placemark: selectedPin)
        } else if let location = locations.first { // move to user location
            let center = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: false)
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("** error:: \(error)")
    }
}

// MARK: - UISearchBarDelegate
extension SearchPlacesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("** searchBarShouldBeginEditing")
        if let mapView = mapView {
            for annotation in mapView.annotations {
                mapView.deselectAnnotation(annotation, animated: true)
            }
        }
        return true
    }
}


// MARK: - HandleMapSearch
extension SearchPlacesViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        mapView.removeAnnotations(mapView.annotations)
        let annotation = CustomAnnotation(placemark: placemark,
                                          biased: mapView.userLocation.coordinate.isEqual(placemark.coordinate))
        
        
        print("*** dropping place mark:", placemark)
        annotation.title = placemark.name
        annotation.subtitle = placemark.address()
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension CLLocationCoordinate2D {
    func isEqual(_ another: CLLocationCoordinate2D) -> Bool {
        return self.latitude == another.latitude && self.longitude == another.longitude
    }
}
