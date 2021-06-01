//
//  MainVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 31/05/2021.
//

import UIKit
import MapKit
import LBTATools

class MainVC: UIViewController {
    
    // MARK:- Views
    let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureRegionForMap()
//        placePins()
        localSearch()
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.fillSuperview()
        mapView.delegate = self
    }
    
    private func configureRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func placePins() {
        let coords = [CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290),.init(latitude: 73.3326, longitude: -122.030024)]
        let titles = ["San Francisco","Apple Campus"]
        let subTitles = ["CA","Cupertino"]
        for i in coords.indices {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords[i]
            annotation.title = titles[i]
            annotation.subtitle = subTitles[i]
            mapView.addAnnotation(annotation)
        }
        
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
   
    private func localSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "kfc"
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            response?.mapItems.forEach({ mapItem in
                let placemark = mapItem.placemark
                let addressString = self.getAddressDetails(placemark)
                print(addressString)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.coordinate
                annotation.title = mapItem.name
                annotation.subtitle = placemark.subThoroughfare
                self.mapView.addAnnotation(annotation)
            })
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    fileprivate func getAddressDetails(_ placemark: MKPlacemark)-> String {
        var addressString = ""
        if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country!
        }
        return addressString
    }
}

// MARK:- MapDelegate
extension MainVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        // resize image
        let pinImage = #imageLiteral(resourceName: "tourist")
        pinImage.withRenderingMode(.alwaysOriginal)
        let size = CGSize.init(width: 25, height: 42)
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        annotationView.image = resizedImage
        return annotationView
    }
}

// MARK:- SwiftUI Preview
import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> MainVC {
            return MainVC()
        }
        
        func updateUIViewController(_ uiViewController: MainVC, context: Context) {}
        
        typealias UIViewControllerType = MainVC
    }
}
