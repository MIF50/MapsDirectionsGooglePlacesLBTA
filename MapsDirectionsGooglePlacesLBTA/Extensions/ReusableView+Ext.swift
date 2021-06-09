//
//  ReusableView+Ext.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
