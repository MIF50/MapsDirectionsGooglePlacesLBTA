//
//  RouteStepCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit
import MapKit

class RouteStepCell: BaseCollectionCell<MKRoute.Step> {
        
    override var item: MKRoute.Step! {
        didSet {
            nameLabel.text = item.instructions
            let milesConversion = item.distance * 0.00062137
            distanceLabel.text = String(format: "%.2f mi", milesConversion)
        }
    }
    
    // MARK:- Views
    private let nameLabel = UILabel(text: "name", font: .systemFont(ofSize: 18))
    private let distanceLabel = UILabel(text: "mile", font: .systemFont(ofSize: 14))
    
    override func setupViews() {
        super.setupViews()
        hstack(nameLabel,distanceLabel,spacing: 4)
            .withMargins(.allSides(12))
        addSeparatorView()
    }
}
