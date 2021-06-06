//
//  LocationCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 05/06/2021.
//

import UIKit
import MapKit

// MARK:- LocationCell
class LocationCell: UICollectionViewCell {
    
    static let reuseId = "LocationCell"
   
    var item: MKMapItem! {
        didSet {
            titleLabel.text = item.placemark.title
            addressLabel.text = item.placemark.address()
            locatoinLabel.text = "\(item.placemark.lat) , \(item.placemark.long)"
        }
    }
    
    // MARK:- Views
    private let titleLabel = UILabel(
        text: "title",
        font: .boldSystemFont(ofSize: 18)
    )
    
    private let addressLabel = UILabel(
        text: "Address",
        numberOfLines: 0
    )
    
    private let locatoinLabel = UILabel(
        text: "Locatoin",
        font: .systemFont(ofSize: 14),
        numberOfLines: 2
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        let vstack = stack(UIView(),titleLabel,addressLabel,locatoinLabel,UIView())
            .withMargins(.allSides(16))
        vstack.spacing = 6
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
