//
//  CalloutContainer.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 10/06/2021.
//

import UIKit

class CalloutContainer: UIView {
    
    // MARK:- Views
    private let imageView:UIImageView  = {
        let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel(textAlignment: .center)
        return nameLabel
    }()
    private let labelContainer: UIView = {
        let labelContainer = UIView(backgroundColor: .white)
        return labelContainer
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .darkGray
        spinner.startAnimating()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSuperView()
        addingViews()
    }
    
    private func configureSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 5
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .darkGray)
    }
    
    private func addingViews() {
        [spinner,imageView].forEach {
            self.addSubview($0)
            $0.fillSuperview()
        }
        // label
        labelContainer.stack(nameLabel)
        stack(UIView(), labelContainer.withHeight(30))
    }
    
    func update(image: UIImage, title: String?) {
        imageView.image = image
        nameLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
