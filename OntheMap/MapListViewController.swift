//
//  MapTableViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/11/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class MapListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var locations: [StudentLocation] = []
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locations = (appDelegate.locations)!

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MapViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // open web controller going to link

        true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let location = locations[indexPath.row]

        guard let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MapViewCell") else {
            print("Cannot find MapViewCell")
            return UITableViewCell()
        }

        cell.textLabel?.text = "\(location.properties[ParseClient.JSONBodyKeys.firstName]) \(location.properties[ParseClient.JSONBodyKeys.lastName]) "
        cell.detailTextLabel?.text = "\(location.properties[ParseClient.JSONBodyKeys.mediaURL])"

        return cell
    }
}