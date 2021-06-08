//
//  LocatoinSearchCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 07/06/2021.
//

import UIKit
import MapKit
import LBTATools

// MARK:- LocationSearchCell
class LocationSearchCell: BaseCollectionCell<MKMapItem> {
        
    override var item: MKMapItem! {
        didSet {
            titleLabel.text = item.name
            addressLabel.text = item.placemark.address()
        }
    }
    
    // MARK:- Views
    private let titleLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 17))
    private let addressLabel = UILabel(text: "address", font: .systemFont(ofSize: 16))
    
    override func setupViews() {
        super.setupViews()
        stack(titleLabel,addressLabel,spacing: 4)
           .withMargins(.allSides(16))
        addSeparatorView()
    }
}
