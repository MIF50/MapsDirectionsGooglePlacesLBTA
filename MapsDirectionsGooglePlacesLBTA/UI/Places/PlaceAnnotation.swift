//
//  PlaceAnnotation.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 10/06/2021.
//

import Foundation
import MapKit
import GooglePlaces

class PlaceAnnotation: MKPointAnnotation {
    let place: GMSPlace
    init(place: GMSPlace) {
        self.place = place
    }
}
