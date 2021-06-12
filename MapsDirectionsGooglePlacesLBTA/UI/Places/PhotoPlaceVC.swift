//
//  PhotoPlaceVC.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 12/06/2021.
//

import UIKit
import SwiftUI

class PhotoCell: BaseCollectionCell<UIImage> {
    // MARK:- Views
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override var item: UIImage! {
        didSet {
            imageView.image = item
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .red
        addSubview(imageView)
        imageView.fillSuperview()
    }
}

class PhotoPlaceVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let colletion = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        colletion.translatesAutoresizingMaskIntoConstraints = false
        return colletion
    }()
    
    // MARK:- Handler
    private let handler = PhotoPlaceHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectoinView()
    }
    
    private func configureCollectoinView() {
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        handler.setup(collectionView)
    }
    
    func addImages(_ images:[UIImage]) {
        handler.items = images
        collectionView.reloadData()
    }
}

// MARK:- PhotoPlaceHandler
class PhotoPlaceHandler: BaseCollectoinHandler<PhotoCell,UIImage> {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
}

// MARK:- Create
extension PhotoPlaceVC {
    static func create() -> PhotoPlaceVC {
        let vc = PhotoPlaceVC()
        vc.title = "Photos"
        return vc
    }
}

// MARK:- PreviewDesign
struct PhotoPlaceVCPreview:PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            return PhotoPlaceVC.create()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
