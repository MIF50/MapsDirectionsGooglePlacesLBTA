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
class LocationSearchCell: UICollectionViewCell {
    
    static let id = "LocationSearchCell"
    
    var itemMap: MKMapItem! {
        didSet {
            titleLabel.text = itemMap.name
            addressLabel.text = itemMap.placemark.address()
        }
    }
    
    // MARK:- Views
    private let titleLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 17))
    private let addressLabel = UILabel(text: "address", font: .systemFont(ofSize: 16))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         stack(titleLabel,addressLabel,spacing: 4)
            .withMargins(.allSides(16))
        addSeparator(at: .bottom, color: .lightGray, weight: 0.5,insets: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
