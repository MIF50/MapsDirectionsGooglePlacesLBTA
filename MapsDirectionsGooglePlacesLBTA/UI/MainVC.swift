//
//  MainVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 31/05/2021.
//

import UIKit
import MapKit
import LBTATools
import Combine

class MainVC: UIViewController {
  
    // MARK:- Views
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        return map
    }()
    private let searchView = SearchView()
    private let locationVC = LocationCarouselVC()
    
    private let locationManager = CLLocationManager()
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserLocation()
        configureMap()
        configureRegionForMap()
        configureSearch()
        placePins()
        localSearch(query: "")
        configureLocationCarousel()
    }
    
    private func requestUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.fillSuperview()
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func configureRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
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
    
   
    private func localSearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            /// remove old annotatoin
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.locationVC.removeItems()
            
            response?.mapItems.forEach({ mapItem in
                let placemark = mapItem.placemark
                print(placemark.address())
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.coordinate
                annotation.title = mapItem.name
                annotation.subtitle = placemark.subThoroughfare
                self.mapView.addAnnotation(annotation)
                self.locationVC.addItem(item: mapItem)
            })
            self.locationVC.scrolToFirstItem()
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
        
    private func configureSearch() {
        view.addSubview(searchView)
        searchView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        searchView.delegate = self
    }
    
    private func configureLocationCarousel() {
        locationVC.mainVC = self
        let carouselView = locationVC.view!
        view.addSubview(carouselView)
        carouselView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            size: .init(width: 0, height: 150)
        )
    }
    
    func setAnnotation(_ mapItem: MKMapItem) {
        self.mapView.annotations.forEach { annotation in
            if annotation.title == mapItem.name {
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }

}

// MARK:- LocationManagerDelegate
extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Recieved authorization of user location")
            locationManager.startUpdatingLocation()
        default:
            print("Failed to authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        mapView.setRegion(.init(center: firstLocation.coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
//        locationManager.stopUpdatingLocation()
    }
}

// MARK:- SearchViewDelegate
extension MainVC :SearchViewDelegate {
    func onSearch(query: String) {
        localSearch(query: query)
    }
}

// MARK:- MapDelegate
extension MainVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            annotationView.canShowCallout = true
    //        annotationView.image = #imageLiteral(resourceName: "tourist").resize(.init(width: 25, height: 42))
            return annotationView
        }
        return nil
    }
}

extension UIImage {
    
    // resize image
    func resize(_ size: CGSize)-> UIImage? {
        withRenderingMode(.alwaysOriginal)
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        return resizedImage
    }
}

// MARK:- PlaceMarkExt
extension MKPlacemark {

    var lat: Double {
        get {
            return location?.coordinate.latitude ?? 0
        }
    }
    
    var long: Double {
        get {
            return location?.coordinate.longitude ?? 0
        }
    }
    
     func address()-> String {
        var addressString = ""
        if subThoroughfare != nil {
            addressString = subThoroughfare! + " "
        }
        if thoroughfare != nil {
            addressString += thoroughfare! + ", "
        }
        if postalCode != nil {
            addressString += postalCode! + " "
        }
        if locality != nil {
            addressString += locality! + ", "
        }
        if administrativeArea != nil {
            addressString += administrativeArea! + " "
        }
        if country != nil {
            addressString += country!
        }
        return addressString
    }

}


// MARK:- SearchView
class SearchView: UIView {
    
    // MARK:- Views
    private let searchTextField: UITextField = {
        let text = UITextField(placeholder: "Enter your search")
        return text
    }()
    
    private var token = Set<AnyCancellable>()
    
    var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        stack(searchTextField).withMargins(.allSides(16))
        setupSearch()
    }
    
    private func setupSearch() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification,object: searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { output in
                if let text = self.searchTextField.text {
                    self.delegate?.onSearch(query: text)
                }
            }
            .store(in: &token)
    }
    
    func onCancel() {
        token.forEach { $0.cancel() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SearchViewDelegate {
    func onSearch(query: String)
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
