//
//  UIView+Ext.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 06/06/2021.
//

import UIKit


extension UIView {
    func setShadow(opacity:Float = 0.2,radius:CGFloat = 5 ,color: UIColor = .black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: layer.cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
