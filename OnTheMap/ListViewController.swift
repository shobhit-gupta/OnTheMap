//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var otmNavigationItemController: OTMNavigationItemController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createOTMNavigationItemController(&otmNavigationItemController)
    }


}


extension ListViewController: OTMNavigationItemControllerProtocol {}
