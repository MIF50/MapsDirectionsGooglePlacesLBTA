//
//  LocationCarouselVc.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 03/06/2021.
//

import UIKit
import MapKit

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
        handler.didTapCell = { indexPath, itemMap in
            self.mainVC?.setAnnotation(itemMap)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        handler.items = []
        collectionView.reloadData()
    }
    
    func addItems(items: [MKMapItem]) {
        handler.items = items
        collectionView.reloadData()
    }
    
    func addItem(item: MKMapItem) {
        handler.items.append(item)
        collectionView.reloadData()
    }
    
    func scrolToFirstItem() {
        collectionView.scrollToItem(at: [0,0], at: .centeredHorizontally, animated: true)
    }
    
    func scrollTo(_ annotation: CustomAnnotation) {
        guard let index = handler.items.firstIndex(where: { $0.name == annotation.mapItem?.name }) else { return }
        collectionView.scrollToItem(at: [0,index], at: .centeredHorizontally, animated: true)
    }
}

// MARK:- LocationHandler
class LocationCarouselHandler: BaseCollectoinHandler<LocationCell,MKMapItem> {

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 64, height: collectionView.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
 

