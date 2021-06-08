//
//  LocationSearchVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 07/06/2021.
//

import UIKit
import MapKit
import LBTATools
import SwiftUI
import JGProgressHUD
import Combine

class LocationSearchVC: UIViewController {
    
    // MARK:- Views
    private let backIcon: UIButton = {
        let buttton = UIButton(image: #imageLiteral(resourceName: "back_arrow"))
        buttton.tintColor = .black
        buttton.withSize(.init(width: 28, height: 30))
        buttton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return buttton
    }()
    private let searchTextField: IndentedTextField = {
        let field = IndentedTextField(placeholder: "Enter your search", padding: 12, cornerRadius: 6)
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.becomeFirstResponder()
        return field
    }()
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        return collection
    }()
    private lazy var progress: JGProgressHUD = {
        let progress = JGProgressHUD()
        progress.textLabel.text = "Loading..."
        progress.style = .dark
        return  progress
    }()
    
    let navHeight: CGFloat = 66
    
    // MARK:- Handler
    private let handler = LocatoinSearchHandler()
    var selectionHandler:((MKMapItem)-> Void)?
    
    var token = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        configureSearchListener()
        locateSearch()
    }
    
    private func configureCollectionView() {
        collectionView.contentInset = .init(top: navHeight, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        collectionView.fillSuperview()

        handler.setup(collectionView)
        handler.didTapCell = { [weak self] _, mapItem in
            self?.navigationController?.popViewController(animated: true)
            self?.selectionHandler?(mapItem)
        }
    }
    
    private func configureNavBar() {
        let navBar = UIView(backgroundColor: .white)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        navBar.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -navHeight, right: 0)
        )
        let containver = UIView()
        navBar.addSubview(containver)
        containver.fillSuperviewSafeAreaLayoutGuide()
        
        containver.hstack(backIcon,searchTextField,spacing: 16 ,distribution: .fill)
            .withMargins(.init(top: 8, left: 16, bottom: 12, right: 16))
    }
    
    private func configureSearchListener() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification,object: searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.locateSearch()
            }
            .store(in: &token)
    }
    
    private func locateSearch() {
        if searchTextField.text?.isEmpty == true {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        let search = MKLocalSearch(request: request)
        progress.show(in: view)
        search.start { [weak self]response, error in
            self?.progress.dismiss()
            if let error = error {
                print("Error in locaton search: \(error.localizedDescription)")
                return
            }
            self?.handler.items = response?.mapItems ?? []
            self?.collectionView.reloadData()
        }
    }
    
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- Create
extension LocationSearchVC {
    static func create()-> LocationSearchVC {
        let vc = LocationSearchVC()
        return vc
    }
}

// MARK:- LocatoinSearchHandler
class LocatoinSearchHandler:BaseCollectoinHandler<LocationSearchCell,MKMapItem> {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 70)
    }
}


// MARK:- PreviewDesign
struct LocationSearchPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            LocationSearchVC()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
