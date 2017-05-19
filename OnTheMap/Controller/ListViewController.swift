//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit


struct PlaceHolderModelCell {
    let name: String
    let url: URL
}


class ListViewController: UITableViewController {

    var otmNavigationItemController: OTMNavigationItemController?
    var placeHolderModel = [PlaceHolderModelCell]()
    var tableViewDataSource: ArrayTableViewDataSource<ListViewController>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createOTMNavigationItemController(&otmNavigationItemController)
        createTableViewDataSource()
        testWithRandomData()
    }


}


extension ListViewController: OTMNavigationItemControllerProtocol {}


extension ListViewController {
    
    func testWithRandomData() {
        createData()
    }
    
    
    func createData() {
        let count = Int.random(in: 1...200)
        for i in 1...count {
            placeHolderModel.append(PlaceHolderModelCell(name: "Row \(i)", url: URL(string: "http://www.google.com")!))
        }
        
    }
    
}


extension ListViewController: ArrayTableViewDataSourceController {
    
    typealias ElementType = PlaceHolderModelCell
    typealias CellType = UITableViewCell
    
    var source: [PlaceHolderModelCell] {
        return placeHolderModel
    }
    
    var reusableCellIdentifier: String {
        return Default.ListViewCell.ReusableCellId
    }
    
    
    func configureCell(_ cell: UITableViewCell, with dataItem: PlaceHolderModelCell) {
        cell.textLabel?.text = dataItem.name
    }
    
    
    func createTableViewDataSource() {
        tableViewDataSource = ArrayTableViewDataSource(withController: self, for: tableView)
    }

    
}





