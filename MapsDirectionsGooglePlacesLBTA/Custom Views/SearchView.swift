//
//  SearchView.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 05/06/2021.
//

import UIKit
import Combine

// MARK:- SearchView
class SearchView: UIView {
    
    // MARK:- Views
    private let searchTextField: UITextField = {
        let text = UITextField(placeholder: "Enter your search")
        return text
    }()
    
    private var token = Set<AnyCancellable>()
    
    var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        stack(searchTextField).withMargins(.allSides(16))
        setupSearch()
    }
    
    private func setupSearch() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification,object: searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { output in
                if let text = self.searchTextField.text {
                    self.delegate?.onSearch(query: text)
                }
            }
            .store(in: &token)
    }
    
    func onCancel() {
        token.forEach { $0.cancel() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SearchViewDelegate {
    func onSearch(query: String)
}
