//
//  AppDelegate.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 31/05/2021.
//

import UIKit
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initGooglePlaces()

        return true
    }
    
    private func initGooglePlaces()  {
        GMSPlacesClient.provideAPIKey("AIzaSyCBLtFbIX9dBXvczs1plz-ddo8t6IyHPqE")
    }
}

