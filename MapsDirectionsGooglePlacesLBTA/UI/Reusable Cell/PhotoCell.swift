//
//  PhotoCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 12/06/2021.
//

import UIKit

class PhotoCell: BaseCollectionCell<UIImage> {
    // MARK:- Views
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override var item: UIImage! {
        didSet {
            imageView.image = item
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        imageView.fillSuperview()
    }
}
