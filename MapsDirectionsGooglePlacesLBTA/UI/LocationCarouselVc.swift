//
//  LocationCarouselVc.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 03/06/2021.
//

import UIKit
import MapKit

let newlines = CharacterSet.newlines.allCharacters

extension CharacterSet {
    var allCharacters: [Character] {
        var result: [Character] = []
        for plane: UInt8 in 0...16 where self.hasMember(inPlane: plane) {
            for unicode in UInt32(plane) << 16 ..< UInt32(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), self.contains(uniChar) {
                    result.append(Character(uniChar))
                }
            }
        }
        return result
    }
}

class LocationCarouselVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collection
    }()
    
    // MARK:- Handler
    private let handler = LocationCarouselHandler()
    
    weak var mainVC: MainVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        ///Action
        handler.didTapItem = { itemMap in
            
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        handler.setup(collectionView)
    }
    
    func removeItems() {
        handler.indexData = []
        collectionView.reloadData()
    }
    
    func addItems(items: [MKMapItem]) {
        handler.indexData = items
        collectionView.reloadData()
    }
    
    func addItem(item: MKMapItem) {
        handler.indexData.append(item)
        collectionView.reloadData()
    }
}

// MARK:- LocationHandler
class LocationCarouselHandler: NSObject,UICollectionViewDataSource, UICollisionBehaviorDelegate,UICollectionViewDelegateFlowLayout {
    
    var indexData = [MKMapItem]()
    var didTapItem:((MKMapItem)-> Void)?
    
    func setup(_ collectoinView: UICollectionView){
        collectoinView.dataSource = self
        collectoinView.delegate = self
        collectoinView.register(LocationCell.self, forCellWithReuseIdentifier:  LocationCell.reuseId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.reuseId, for: indexPath) as! LocationCell
        cell.item = indexData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 64, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapItem?(indexData[indexPath.item])
    }
}
 
// MARK:- LocationCell
class LocationCell: UICollectionViewCell {
    
    static let reuseId = "LocationCell"
   
    var item: MKMapItem! {
        didSet {
            titleLabel.text = item.placemark.title
            addressLabel.text = item.placemark.address()
            locatoinLabel.text = "lat: \(item.placemark.lat) \nlong: \(item.placemark.long)"
        }
    }
    
    // MARK:- Views
    private let titleLabel = UILabel(
        text: "title",
        font: .boldSystemFont(ofSize: 18)
    )
    private let addressLabel = UILabel(
        text: "Address",
        numberOfLines: 0
    )
    private let locatoinLabel = UILabel(
        text: "Locatoin",
        font: .systemFont(ofSize: 14),
        numberOfLines: 2
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        let vstack = stack(UIView(),titleLabel,addressLabel,locatoinLabel,UIView())
            .withMargins(.allSides(16))
        vstack.spacing = 6
        setShadow()
    }
    
    private func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
