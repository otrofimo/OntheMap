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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)

        guard
            let sourceLocations = self.appDelegate.locations
        else {
            print("Locations not loaded")
            return
        }

        self.locations = sourceLocations

        setAnnotationsFromLocations(locations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()

            pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoDark)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if let annotationView = view.annotation {

            // Is there a better way to convert String?? to String
            if let mediaURLString = (annotationView.subtitle?.flatMap{$0}) {
                let url = NSURL(string: mediaURLString)
                UIApplication.sharedApplication().openURL(url!)
            }
        }
    }

    func setAnnotationsFromLocations(locations: [StudentLocation]) {
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
}
