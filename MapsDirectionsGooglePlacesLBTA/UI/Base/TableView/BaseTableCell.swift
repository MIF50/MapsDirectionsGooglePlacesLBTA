//
//  BaseTableViewCell.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit

@available(iOS 11.0, tvOS 11.0, *)
open class BaseTableCell<T>: UITableViewCell {
    
    open var item: T!
    public let separatorView = UIView(backgroundColor: UIColor(white: 0.6, alpha: 0.5))

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    open func setupViews() {}
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- ReusableView
extension BaseTableCell:ReusableView {}
