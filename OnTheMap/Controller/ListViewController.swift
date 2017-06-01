//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit


class ListViewController: UITableViewController {

    // MARK: Private variables and types
    fileprivate var tableViewDataSource: ArrayTableViewDataSource<ListViewController>? = nil
    internal var otmNavigationItemController: OTMNavigationItemController?
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotification()
    }


}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension ListViewController {
    
    fileprivate func setupUI() {
        setupNavigationItem()
    }
    
    
    private func setupNavigationItem() {
        createOTMNavigationItemController(&otmNavigationItemController)
        otmNavigationItemController?.otmNavigationItem?.title = Default.ListView.Title
    }
    
    
}


//******************************************************************************
//                  MARK: OTMNavigationItemControllerProtocol
//******************************************************************************
extension ListViewController: OTMNavigationItemControllerProtocol {}


//******************************************************************************
//                  MARK: ArrayTableViewDataSourceController
//******************************************************************************
extension ListViewController: ArrayTableViewDataSourceController {
    
    typealias ElementType = Udacity.Student
    typealias CellType = UITableViewCell
    
    var source: [Udacity.Student] {
        return OTMModel.shared.students
    }
    
    var reusableCellIdentifier: String {
        return Default.ListViewCell.ReusableCellId
    }
    
    
    func configureCell(_ cell: UITableViewCell, with dataItem: Udacity.Student) {
        cell.textLabel?.text = "\(dataItem.firstName) \(dataItem.lastName)"
        cell.detailTextLabel?.text = dataItem.mediaURL?.absoluteString ?? "Hasn't shared any link"
    }
    
    
    func createDataSource() {
        tableViewDataSource = ArrayTableViewDataSource(withController: self, for: tableView)
    }

    
}


//******************************************************************************
//                           MARK: UITableViewDelegate
//******************************************************************************
extension ListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataItem = tableViewDataSource?.dataItem(at: indexPath),
            let url = dataItem.mediaURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//******************************************************************************
//                              MARK: Notifications
//******************************************************************************
extension ListViewController {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(studentsLocationModified(_:)),
                                               name: Notification.Name(rawValue: Default.Notification.StudentsLocationModified.rawValue),
                                               object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func studentsLocationModified(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
}


