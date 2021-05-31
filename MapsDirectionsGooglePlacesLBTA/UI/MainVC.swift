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
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureRegionForMap()
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.fillSuperview()
        mapView.mapType = .standard
    }
    
    private func configureRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
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
