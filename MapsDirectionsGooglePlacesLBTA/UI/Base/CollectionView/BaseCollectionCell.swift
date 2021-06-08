//
//  BaseCollectionViewCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit

@available(iOS 11.0, tvOS 11.0, *)
open class BaseCollectionCell<T>: UICollectionViewCell {
    
    open var item: T!
        
    public let separatorView = UIView(backgroundColor: UIColor(white: 0.6, alpha: 0.5))
    
    open func addSeparatorView(leftPadding: CGFloat = 0) {
        addSubview(separatorView)
        separatorView.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: leftPadding, bottom: 0, right: 0),
            size: .init(width: 0, height: 0.5)
        )
    }
    
    open func addSeparatorView(leadingAnchor: NSLayoutXAxisAnchor) {
        addSubview(separatorView)
        separatorView.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            size: .init(width: 0, height: 0.5)
        )
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    open func setupViews() {}
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- ReusableView
extension BaseCollectionCell:ReusableView {}
