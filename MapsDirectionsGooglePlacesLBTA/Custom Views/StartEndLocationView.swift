//
//  StartEndLocationView.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 06/06/2021.
//

import UIKit
import LBTATools

class StartEndLocationView: UIView {
    // MARK:- Views
    private let startTextField = IndentedTextField(padding: 12, cornerRadius: 5)
    private let endTextField = IndentedTextField(padding: 12, cornerRadius: 5)
    private let startIcon = UIImageView(image: #imageLiteral(resourceName: "start_location_circles"), contentMode: .scaleAspectFit)
    private let endIcon = UIImageView(image: #imageLiteral(resourceName: "annotation_icon"), contentMode: .scaleAspectFit)
    
    var delegate: StartEndLocationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        hangleTapGestures()
    }
    
    private func setupView() {
        [startIcon,endIcon].forEach {
            $0.image = $0.image?.imageWithColor(color: .white)
            $0.withWidth(20)
        }
        
        [startTextField,endTextField].forEach {
            $0.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
            $0.textColor = .white
        }
        startTextField.attributedPlaceholder = .init(string: "Start", attributes: [.foregroundColor:UIColor.init(white: 1, alpha: 0.7)])
        endTextField.attributedPlaceholder = .init(string: "End", attributes: [.foregroundColor:UIColor.init(white: 1, alpha: 0.7)])
       
        let startStack = hstack(startIcon,startTextField,spacing: 16)
        let endStack = hstack(endIcon,endTextField,spacing: 16)
        stack(startStack,endStack,spacing: 12,distribution: .fillEqually)
            .withMargins(.init(top: 0, left: 16, bottom: 12, right: 16))
        
    }
    
    private func hangleTapGestures() {
        startTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStartTextField)))
        endTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEndTextField)))
    }
    
    @objc private func didTapStartTextField() {
        delegate?.didTapStartTextField()
    }
    
    @objc private func didTapEndTextField() {
        delegate?.didTapEndTextField()
    }
    
    func updateStartText(_ text: String) {
        startTextField.text = text
    }
    
    func updateEndText(_ text: String) {
        endTextField.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol StartEndLocationViewDelegate {
    func didTapStartTextField()
    func didTapEndTextField()
}

