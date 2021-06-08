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

class RoutesVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        return collection
    }()
    
    // MARK:- Handler
    private let handler = RoutesHander()
    
    var route: MKRoute! {
        didSet {
            handler.route = route
        }
    }
    
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
    var route: MKRoute!
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RouteStepCell.self, forCellWithReuseIdentifier: RouteStepCell.id)
        collectionView.register(RouteHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RouteHeader.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RouteHeader.id, for: indexPath) as! RouteHeader
        header.setupHeaderInformation(route: route)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 100)
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
        ContainerView()
            .previewLayout(.sizeThatFits)
                        .padding()
                        .previewDisplayName("Default preview")
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            return RoutesVC.create()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

struct UIElementPreview<Value: View>: View {

    private let dynamicTypeSizes: [ContentSizeCategory] = [.extraSmall, .large, .extraExtraExtraLarge]

    /// Filter out "base" to prevent a duplicate preview.
    private let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    private let viewToPreview: Value

    init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }

    var body: some View {
        Group {
            self.viewToPreview
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Default preview 1")

            self.viewToPreview
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")

            ForEach(localizations, id: \.identifier) { locale in
                self.viewToPreview
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.locale, locale)
                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
            }

            ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in
                self.viewToPreview
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName("\(sizeCategory)")
            }

        }
    }
}
