//
//  MKPlacemark+Ext.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 05/06/2021.
//

import UIKit
import MapKit

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
