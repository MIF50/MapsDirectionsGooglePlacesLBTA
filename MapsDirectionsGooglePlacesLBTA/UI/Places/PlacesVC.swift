//
//  PlacesVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 10/06/2021.
//

import UIKit
import SwiftUI
import GooglePlaces
import LBTATools
import MapKit

class PlacesVC: UIViewController {
    
    // MARK:- Views
    private let mapView = MKMapView()
    private var currentCustomCallout: UIView?
    private let hudContainer = HUDContainer()
    
    private let locationManager = CLLocationManager()
    private let client = GMSPlacesClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        requestForLocationAuthorization()
        configureHudContainer()
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.fillSuperview()
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    private func requestForLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func findNearbyPlaces() {
        client.currentPlace { [weak self] likelihoodList, error in
            if let error = error {
                print("failed to find current places: \(error.localizedDescription)")
                return
            }
            
            likelihoodList?.likelihoods.forEach({  likehood in
                print(likehood.place.name ?? "")
                let place = likehood.place
                let annotation = PlaceAnnotation(place: place)
                annotation.title = place.name
                annotation.coordinate = place.coordinate
                self?.mapView.addAnnotation(annotation)
            })
            self?.mapView.showAnnotations(self?.mapView.annotations ?? [], animated: false)
        }
    }
    
    fileprivate func configureHudContainer() {
        view.addSubview(hudContainer)
        hudContainer.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .allSides(16),
            size: .init(width: 0, height: 125)
        )
        
    }
    
    fileprivate func setupHUD(_ placeAnnotation: PlaceAnnotation) {
        hudContainer.setupHUD(placeAnnotation)
    }
}

// MARK:- MapViewDelegate
extension PlacesVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation) {
            return nil
        }
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        
        if let placeAnnotation = annotation as? PlaceAnnotation {
            let types = placeAnnotation.place.types
            if let firstType = types?.first {
                if firstType == "bar" {
                    annotationView.image = #imageLiteral(resourceName: "bar")
                } else if firstType == "restaurant" {
                    annotationView.image = #imageLiteral(resourceName: "restaurant")
                } else {
                    annotationView.image = #imageLiteral(resourceName: "tourist")
                }
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let placeAnnotation = (view.annotation as? PlaceAnnotation) else { return }
        setupHUD(placeAnnotation)
        
        currentCustomCallout?.removeFromSuperview()
        var widthAnchor: NSLayoutConstraint!
        var heightAnchor: NSLayoutConstraint!
        let customCalloutContainer = createAndConfigureCalloutContainer(in: view)
        currentCustomCallout = customCalloutContainer
        
        
        // lookup our photo
        guard  let firstPhotoMetaData = placeAnnotation.place.photos?.first else { return }
        self.client.loadPlacePhoto(firstPhotoMetaData, callback: { image, error in
            if let error = error {
                print("Failed to load for place: ", error)
                return
            }
            
            guard let image = image else { return }
            let bestSize = bestCalloutImageSize(for: image)
            widthAnchor.constant = bestSize.width
            heightAnchor.constant = bestSize.height
            customCalloutContainer.update(image: image, title: placeAnnotation.place.name)
        })
        
        // helper method
        func createAndConfigureCalloutContainer(in view: MKAnnotationView)-> CalloutContainer {
            let customCalloutContainer = CalloutContainer()
            view.addSubview(customCalloutContainer)
            
            widthAnchor = customCalloutContainer.widthAnchor.constraint(equalToConstant: 100)
            widthAnchor.isActive = true
            heightAnchor = customCalloutContainer.heightAnchor.constraint(equalToConstant: 200)
            heightAnchor.isActive = true
            customCalloutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            customCalloutContainer.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
            return customCalloutContainer
        }
        
        func bestCalloutImageSize(for image: UIImage)-> CGSize {
            if image.size.width > image.size.height {
                // w1/h1 = w2/h2
                let newWidth: CGFloat = 300
                let newHeight = newWidth / image.size.width * image.size.height
                return .init(width: newWidth, height: newHeight)
            } else {
                let newHeight: CGFloat = 200
                let newWidth = newHeight / image.size.height * image.size.width
                return .init(width: newWidth, height: newHeight)
            }
        }
    }
}

// MARK:- LocationManaggerDelegate
extension PlacesVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)
        self.mapView.setRegion(region, animated: false)
        findNearbyPlaces()
    }
}

// MARK:- Create
extension PlacesVC {
    static func create()-> PlacesVC {
        let vc = PlacesVC()
        return vc
    }
}

// MARK:- PreveiewDesign
struct PlacesVCPreview: PreviewProvider  {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            PlacesVC.create()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
