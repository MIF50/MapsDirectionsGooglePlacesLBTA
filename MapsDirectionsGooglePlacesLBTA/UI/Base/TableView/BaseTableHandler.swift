//
//  BaseTableViewHandler.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 08/06/2021.
//

import UIKit

class BaseTableHandler<T: BaseTableCell<U>,U>: NSObject,UITableViewDataSource, UITableViewDelegate {
    
    open var items = [U]()
    var didTapCell:((IndexPath,U)-> Void)?
    
    func setup(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(T.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: T = tableView.dequeueReusableCell(for: indexPath)
        cell.item = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTapCell?(indexPath,items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
