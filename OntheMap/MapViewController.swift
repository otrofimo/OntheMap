//
//  MapViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/11/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    var locations: [StudentLocation] = []
    var annotations = [MKPointAnnotation]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)

        guard
            let sourceLocations = self.appDelegate.locations as? [StudentLocation]
        else {
            print("Locations not loaded")
        }

        print(self.locations.count)

        for location in locations {
            let lat = CLLocationDegrees(location.properties[ParseClient.JSONBodyKeys.latitude] as! Double)
            let long = CLLocationDegrees(location.properties[ParseClient.JSONBodyKeys.longitude] as! Double)

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            guard
                let first = location.properties[ParseClient.JSONBodyKeys.firstName] as? String,
                let last = location.properties[ParseClient.JSONBodyKeys.lastName] as? String,
                let mediaURL = location.properties[ParseClient.JSONBodyKeys.mediaURL] as? String
            else {
                print("Missing parameter for location")
                continue
            }

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        // Open web page for link
        true
    }

}
