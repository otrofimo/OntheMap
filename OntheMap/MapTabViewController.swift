//
//  MapTabViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/12/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class MapTabViewController: UITabBarController {

    let parameters = ["limit": "100", "order": "-updatedAt"]

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        ParseClient.sharedInstance.getStudentLocations(parameters) { (locations, error) in
            if let error = error {
                let alertVC = UIAlertController(title: "Error Getting Student Locations", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                return
            }

            if let locations = locations {
                self.appDelegate.locations = locations
            }

            dispatch_async(dispatch_get_main_queue()) {
                if let mapTableVC = self.viewControllers![1] as? MapListViewController {
                    if let tableView = mapTableVC.tableView {
                        tableView.reloadData()
                    }
                }

                if let mapVC = self.viewControllers![0] as? MapViewController {
                    mapVC.annotations = []
                    mapVC.locations = self.appDelegate.locations!
                    mapVC.setAnnotationsFromLocations(mapVC.locations)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func mapPinButtonTapped(sender: UIBarButtonItem) {
    }

    @IBAction func refreshButtonTapped(sender: UIBarButtonItem) {
        ParseClient.sharedInstance.getStudentLocations(parameters) { (locations, error) in
            if let error = error {
                let alertVC = UIAlertController(title: "Error Getting Student Locations", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                return
            }

            if let locations = locations {
                self.appDelegate.locations = locations
            }

            dispatch_async(dispatch_get_main_queue()) {
                if let mapTableVC = self.viewControllers![1] as? MapListViewController {
                    if let tableView = mapTableVC.tableView {
                        tableView.reloadData()
                    }
                }

                if let mapVC = self.viewControllers![0] as? MapViewController {
                    mapVC.annotations = []
                    mapVC.locations = self.appDelegate.locations!
                    mapVC.setAnnotationsFromLocations(mapVC.locations)
                }
            }
        }
    }
}
