//
//  MapTabViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/12/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class MapTabViewController: UITabBarController {

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        getLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func mapPinButtonTapped(sender: UIBarButtonItem) {
    }

    @IBAction func refreshButtonTapped(sender: UIBarButtonItem) {
        getLocations()
    }

    func getLocations() {
        let parameters = ["limit": "100", "order": "-createdAt"]
        ParseClient.sharedInstance.getStudentLocations(parameters) { (locations, error) in

            if let error = error {
                let alertVC = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                return
            }

            self.appDelegate.locations = locations!

            dispatch_async(dispatch_get_main_queue()) {
                if let mapTableVC = self.viewControllers![1] as? MapListViewController {
                    if let tableView = mapTableVC.tableView {
                        tableView.reloadData()
                    }
                }

                if let mapVC = self.viewControllers![0] as? MapViewController {
                    mapVC.annotations = []
                    mapVC.locations = self.appDelegate.locations!
                }
            }
        }
    }


}
