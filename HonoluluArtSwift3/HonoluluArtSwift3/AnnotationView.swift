//
//  AnnotationView.swift
//  HonoluluArtSwift3
//
//  Created by C02GC0VZDRJL on 12/19/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import UIKit
import MapKit
import Contacts


extension ViewController: MKMapViewDelegate {
    
    //MARK: Custom Pin Configuration
    // annotation view configuration
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // only permit annotations of type Artwork
        guard let annotation = annotation as? Artwork else { return nil }
        
        // create placeholder marker
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        // check for reusable annotation view to modify if it exists
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // if no annotation views available for modification, it makes one
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.pinTintColor = annotation.pinTintColor
        }
        return view
    }*/
    
    //MARK: Custom Annotation View
    // same as above, but now we're just using MKAnnotationView and creating a custom annotation view instead of a pin
    // in the tutorial this was done in the "ArtworkView" subclass, but the methods used in Swift 4 do not work in Swift 3, so I just did it in the mapView like we did for the pin customization
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Artwork else { return nil }
        
        let identifier = "customAnnotation"
        var view: MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.canShowCallout = true
            
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            // created a custom UILabel with no limit on lines to fit the long description for the artwork
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = annotation.subtitle
            view.detailCalloutAccessoryView = detailLabel
            
            // replaced the default button with an icon given in the resources
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            view.rightCalloutAccessoryView = mapsButton
            
            if let imageName = annotation.imageName {
                view.image = UIImage(named: imageName)
            } else {
                view.image = nil
            }
        }
        
        return view
    }
    
    //MARK: Connection to Maps app
    // allows Maps to be opened from the annotation, and when it is the user is given driving directions from their location
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}












