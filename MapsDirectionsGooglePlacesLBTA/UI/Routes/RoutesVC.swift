//
//  RoutesVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 07/06/2021.
//

import UIKit
import MapKit
import SwiftUI
import LBTATools
// MARK:- RouteStepCell
class RouteStepCell: UICollectionViewCell {
    
    static let id =  "RouteStepCell"
    
    var item: MKRoute.Step! {
        didSet {
            nameLabel.text = item.instructions
            let milesConversion = item.distance * 0.00062137
            distanceLabel.text = String(format: "%.2f mi", milesConversion)
        }
    }
    
    // MARK:- Views
    private let nameLabel = UILabel(text: "name", font: .systemFont(ofSize: 18))
    private let distanceLabel = UILabel(text: "mile", font: .systemFont(ofSize: 14))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hstack(nameLabel,distanceLabel)
            .withMargins(.allSides(12))
        addSeparator(at: .bottom, color: .lightGray, weight: 0.5, insets: .init(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoutesVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        return collection
    }()
    
    // MARK:- Handler
    private let handler = RoutesHander()
    
    var stepRoutes: [MKRoute.Step]! {
        didSet {
            handler.indexData = stepRoutes
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        handler.setup(collectionView)
    }
}

// MARK:- Create
extension RoutesVC {
    static func create()-> RoutesVC {
        let vc = RoutesVC()
        return vc
    }
}

// MARK:- RoutesHandler
class RoutesHander: NSObject,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var indexData = [MKRoute.Step]()
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RouteStepCell.self, forCellWithReuseIdentifier: RouteStepCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteStepCell.id, for: indexPath) as! RouteStepCell
        cell.item = indexData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 70)
    }
}


// MARK:- Preview Design
struct RoutesPreview: PreviewProvider{
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            return RoutesVC()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
