//
//  MapTableViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/11/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class MapListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
        self.tableView.registerClass(MapTableViewCell.self, forCellReuseIdentifier: "MapTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MapTableViewCell

        if let url = NSURL(string: cell.mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = self.appDelegate.locations {
            return locations.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let actualLocations = appDelegate.locations else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("MapTableViewCell") as! MapTableViewCell

        let location = actualLocations[indexPath.row]

        if let firstName = location.properties[ParseClient.JSONBodyKeys.firstName] as? String, let lastName  = location.properties[ParseClient.JSONBodyKeys.lastName] as? String {
            cell.textLabel?.text = "\(firstName) \(lastName)"
            cell.imageView?.image = UIImage(named: "pin")
        }

        if let mediaURL  = location.properties[ParseClient.JSONBodyKeys.mediaURL] as? String {
            cell.mediaURL = "\(mediaURL)"
        }

        return cell
    }

    func animateTable(){
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height

        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }

        var index = 0

        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
}