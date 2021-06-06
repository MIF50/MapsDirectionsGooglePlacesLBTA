//
//  DirectionsVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 06/06/2021.
//

import UIKit
import MapKit
import LBTATools
import SwiftUI

class DirectionsVC: UIViewController {
    
    // MARK:- Views
    private let navBar: UIView = {
        let view = UIView()
        view.setShadow(opacity: 0.5, radius: 5)
        view.backgroundColor = #colorLiteral(red: 0.2129850388, green: 0.6199089885, blue: 0.9008592963, alpha: 1)
        return view
    }()
    private let startEndLocationView = StartEndLocationView()
    private let mapView = MKMapView()
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureMap()
        configureRegion()
        setupStartEndDummyAnnotations()
        requestForDirections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureNavBar() {
        view.addSubview(navBar)
        navBar.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -120, right: 0)
        )
        navBar.addSubview(startEndLocationView)
        startEndLocationView.fillSuperviewSafeAreaLayoutGuide()
        startEndLocationView.delegate = self
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.anchor(
            top: navBar.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    private func configureRegion() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func setupStartEndDummyAnnotations() {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = .init(latitude: 37.7666, longitude: -122.427290)
        startAnnotation.title = "Start"
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = .init(latitude: 37.331352, longitude: -122.030331)
        endAnnotation.title = "End"
        
        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(endAnnotation)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private func requestForDirections() {
        let request = MKDirections.Request()
        let startPlaceMark = MKPlacemark(coordinate: .init(latitude: 37.7666, longitude: -122.427290))
        request.source = .init(placemark: startPlaceMark)
        let endPlaceMark = MKPlacemark(coordinate: .init(latitude: 37.331352, longitude: -122.030331))
        request.destination = .init(placemark: endPlaceMark)
        request.requestsAlternateRoutes = true
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("failed to make direction: \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else { return }
            print("timeExpected: \(route.expectedTravelTime / 60)")
            self.mapView.addOverlay(route.polyline)
        }
    }
}

// MARK:- StartEndLocatoinViewDelegate
extension DirectionsVC: StartEndLocationViewDelegate {
    func didTapStartTextField() {
        print("didTapStartTextField")
    }
    
    func didTapEndTextField() {
        print("didTapEndTextField")
    }
}

// MARK:- MapView Delegate
extension DirectionsVC: MKMapViewDelegate {
    /// for draw polyline in map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = #colorLiteral(red: 0.2129850388, green: 0.6199089885, blue: 0.9008592963, alpha: 1)
        polylineRender.lineWidth = 5
        return polylineRender
    }
}

extension DirectionsVC {
    static func create()->UIViewController {
        let vc = DirectionsVC()
        return UINavigationController(rootViewController: vc)
    }
}


// MARK:- Preview Design
struct DirectionsPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .light)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            DirectionsVC.create()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
