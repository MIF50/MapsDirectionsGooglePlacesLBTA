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
import Combine

class LocationSearchVC: UIViewController {
    
    // MARK:- Views
    private let backIcon: UIButton = {
        let buttton = UIButton(image: #imageLiteral(resourceName: "back_arrow"))
        buttton.tintColor = .black
        buttton.withSize(.init(width: 30, height: 30))
        buttton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return buttton
    }()
    private let searchTextField: IndentedTextField = {
        let field = IndentedTextField(placeholder: "Enter your search", padding: 12, cornerRadius: 6)
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        return field
    }()
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        return collection
    }()
    
    let navHeight:CGFloat = 66
    
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
        handler.didTapCell = { [weak self] mapItem in
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
        
        containver.hstack(backIcon,searchTextField,spacing: 12,distribution: .fill)
            .withMargins(.init(top: 0, left: 16, bottom: 12, right: 16))
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
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error in locaton search: \(error.localizedDescription)")
                return
            }
            self.handler.indexData = response?.mapItems ?? []
            self.collectionView.reloadData()
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
class LocatoinSearchHandler: NSObject, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    var indexData = [MKMapItem]()
    var didTapCell:((MKMapItem)->Void)?
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LocationSearchCell.self, forCellWithReuseIdentifier: LocationSearchCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationSearchCell.id, for: indexPath) as! LocationSearchCell
        cell.itemMap = indexData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCell?(indexData[indexPath.item])
    }
}


// MARK:- PreviewDesign
struct LocationSearchPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            return LocationSearchVC()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
