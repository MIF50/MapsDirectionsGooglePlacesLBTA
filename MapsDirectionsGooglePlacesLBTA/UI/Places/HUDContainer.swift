//
//  HUDContainer.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 10/06/2021.
//

import UIKit
import MapKit

class HUDContainer: UIView {
    
    // MARK:- Views
    private let hudNameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 16))
    private let hudAddressLabel = UILabel(text: "Address", font: .systemFont(ofSize: 16))
    private let hudTypesLabel = UILabel(text: "Types", textColor: .gray)
    private lazy var infoButton = UIButton(type: .infoLight)
    
    var didTapInfoButton:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        layer.cornerRadius = 5
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .darkGray)
        
        let topRow = UIView()
        topRow.hstack(hudNameLabel, infoButton.withWidth(44))
        hstack(
            stack(topRow,hudAddressLabel,hudTypesLabel, spacing: 8),
            alignment: .center
        ).withMargins(.allSides(16))
        infoButton.addTarget(self, action: #selector(handleTapInfo), for: .touchUpInside)
    }
    
    @objc private func handleTapInfo() {
        self.didTapInfoButton?()
    }
    
    func setupHUD(_ placeAnnotation: PlaceAnnotation) {
        let place = placeAnnotation.place
        hudNameLabel.text = place.name
        hudAddressLabel.text = place.formattedAddress
        hudTypesLabel.text = place.types?.joined(separator: ", ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
