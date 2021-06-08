//
//  RouteHeader.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit
import SwiftUI
import MapKit

class RouteHeader: UICollectionReusableView {
    
    static let id = "RouteHeader"
    
    // MARK:- Views
    private let nameLabel = UILabel(text: "Route", font: .boldSystemFont(ofSize: 18))
    private let distanceLabel = UILabel(text: "Distance", font: .boldSystemFont(ofSize: 18))
    private let estimateLabel = UILabel(text: "Estimate", font: .boldSystemFont(ofSize: 18))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hstack(
            stack(nameLabel,distanceLabel,estimateLabel,spacing: 4),
            alignment: .center
        ).withMargins(.allSides(12))
        
        addSeparator(at: .bottom, color: .lightGray, weight: 0.5, insets: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func setupHeaderInformation(route: MKRoute) {
        nameLabel.attributedText = generateAttributedString(title: "Route", description: route.name)
        
        let milesDistance = route.distance * 0.00062137
        let milesString = String(format: "%.2f mi", milesDistance)
        distanceLabel.attributedText = generateAttributedString(title: "Distance", description: milesString)
        
        var timeString = ""
        if route.expectedTravelTime > 3600 {
            let h = Int(route.expectedTravelTime / 60 / 60)
            let m = Int((route.expectedTravelTime.truncatingRemainder(dividingBy: 60 * 60)) / 60)
            timeString = String(format: "%d hr %d min", h, m)
        } else {
            let time = Int(route.expectedTravelTime / 60)
            timeString = String(format: "%d min", time)
        }
        estimateLabel.attributedText = generateAttributedString(title: "Est Time", description: timeString)
    }
    
    fileprivate func generateAttributedString(title: String, description: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(
            string: title + ": ",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        attributeString.append(
            .init(string: description, attributes: [.font: UIFont.systemFont(ofSize: 16)])
        )
        return attributeString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- PreviewDesign
struct RouteHeaderPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            RouteHeader()
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
}


