//
//  RouteStepCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit
import MapKit

class RouteStepCell: UICollectionViewCell {
    
    static let id =  "RouteStepCell"
    
    var item: MKRoute.Step! {
        didSet {
            nameLabel.text = item.instructions
            let milesConversion = item.distance * 0.00062137
            distanceLabel.text = String(format: "%.2f mi", milesConversion)
        }
    }
    
    // MARK:- Views
    private let nameLabel = UILabel(text: "name", font: .systemFont(ofSize: 18))
    private let distanceLabel = UILabel(text: "mile", font: .systemFont(ofSize: 14))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hstack(nameLabel,distanceLabel,spacing: 4)
            .withMargins(.allSides(12))
        addSeparator(at: .bottom, color: .lightGray, weight: 0.5, insets: .init(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
