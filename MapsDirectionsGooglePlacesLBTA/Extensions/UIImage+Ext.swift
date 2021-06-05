//
//  UIImage+Ext.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 05/06/2021.
//

import UIKit

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
