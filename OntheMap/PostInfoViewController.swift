//
//  PostInfoViewController.swift
//  OntheMap
//
//  Created by Oleg Trofimov on 10/4/15.
//  Copyright © 2015 Oleg Trofimov. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var locationTextView: UIView!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var pinTextView: UITextView!

    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

    override func viewDidLoad() {
        locationTextField.delegate = self
        super.viewDidLoad()
    }

    @IBAction func findOnMap(sender: UIButton) {

        dispatch_async(dispatch_get_main_queue(), {
            self.activityView.hidden = false
            self.activityIndicator.startAnimating()
        })

        let geocoder:CLGeocoder = CLGeocoder()

        guard let location = locationTextField.text
            where location != "" && location.rangeOfString("Enter your location here") == nil
        else {
            let alertVC = UIAlertController(title: "Error", message: "please enter location in location text field", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertVC.addAction(cancelAction)

            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
                self.activityView.hidden = true
                self.presentViewController(alertVC, animated: true, completion: nil)
            })
            return
        }

        geocoder.geocodeAddressString(location) { (placemarks, error) in

            if let _ = error {
                let alertVC = UIAlertController(title: "Error Finding Location", message: "Please check that the location is correct", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)

                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.activityView.hidden = true
                    self.presentViewController(alertVC, animated: true, completion: nil)
                })

                return
            }

            dispatch_async(dispatch_get_main_queue(), {
                self.locationTextView.hidden = true
                self.buttonView.hidden = true
                self.promptLabel.hidden = true

                self.promptView.backgroundColor = self.locationTextView.backgroundColor
                self.pinTextView.hidden  = false
                self.submitButton.hidden = false
            })

            if let placemark = placemarks?.first {

                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate

                let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                pointAnnotation.title = location

                // Sets region to be within a certain limit around coordinate
                let span = MKCoordinateSpanMake(0.1, 0.1) // about 7x7 mile span
                let region = MKCoordinateRegionMake(coordinates, span)
                self.mapView?.setRegion(region, animated: true)

                self.mapView?.addAnnotation(pointAnnotation)
                self.mapView?.selectAnnotation(pointAnnotation, animated: true)
                print("Added annotation to map view")

                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.activityView.hidden = true
                })
            }
        }
    }

    @IBAction func didBeginEditingLocationText(sender: UITextField) {
        sender.text = ""
    }

    func  mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return MKAnnotationView()
    }

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }

        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func submitLocationButtonTapped(sender: UIButton) {
        guard let mediaURL = self.pinTextView.text
            where mediaURL != "" && mediaURL.rangeOfString("Enter your location here") == nil
        else {
                let alertVC = UIAlertController(title: "Error", message: "Please enter a link to share", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertVC.addAction(cancelAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                return
        }

        guard let annotation = mapView.annotations.first else {
            print("Error finding annotation on map")
            return
        }

        // When the app simply loads without going through login, appDelegate is recreated? so need to make call to getUserData

        if let  userFirstName = self.appDelegate?.userFirstName,
                userLastName = self.appDelegate?.userLastName,
                userId = self.appDelegate?.userID as String?,
                mapString = locationTextField?.text
        {
            let studentInfo : [String : AnyObject] = [
                ParseClient.JSONResponseKeys.StudentLocationFirstName   : userFirstName,
                ParseClient.JSONResponseKeys.StudentLocationLastName    : userLastName,
                ParseClient.JSONResponseKeys.StudentLocationLatitude    : annotation.coordinate.latitude,
                ParseClient.JSONResponseKeys.StudentLocationLongitude   : annotation.coordinate.longitude,
                ParseClient.JSONResponseKeys.StudentLocationMapString   : mapString,
                ParseClient.JSONResponseKeys.StudentLocationMediaURL    : mediaURL,
                ParseClient.JSONResponseKeys.StudentLocationUniqueKey   : userId
            ]

            var studentLocation = StudentLocation(dictionary: studentInfo)

            dispatch_async(dispatch_get_main_queue(), {
                self.activityView.hidden = false
                self.activityIndicator.startAnimating()
            })

            ParseClient.sharedInstance.postStudentLocation(&studentLocation) { success, error in

                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.activityView.hidden = true
                })

                if success == true {
                    self.appDelegate?.locations?.append(studentLocation)
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alertVC = UIAlertController(title: "Error Submitting Location", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertVC.addAction(cancelAction)

                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.activityView.hidden = true
                        self.presentViewController(alertVC, animated: true, completion: nil)
                    })
                }
            }
        } else {
            print("missing user information")
        }
    }
}