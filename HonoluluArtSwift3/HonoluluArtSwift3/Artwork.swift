//
//  Artwork.swift
//  HonoluluArtSwift3
//
//  Created by C02GC0VZDRJL on 12/19/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    // create an Artwork class that meets the MKAnnotation protocol (having at least a coordinate variable) and that will let us create artwork objects to display on the map
    
    //MARK: Class Initialization
    let title: String?
    let location: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var imageName: String? {
        if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }
    
    init(title: String, location: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.location = location
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    // attempt to initialize the object from an array passed from the json
    init?(json: [Any]) {
        // the array indices will always correspond to the given initializer values we want, if they are not nil
        self.title = json[16] as? String ?? "No Title"
        
        // replaced the short description in index 12 with the long description in index 11
        //self.location = json[12] as! String
        self.location = json[11] as! String
        
        // the type of landmark, used to determine the pin color coding and custom image
        self.discipline = json[15] as! String
        
        // we gotta convert the latitute and longitude strings to doubles to create coordinates (again, if they're not nil)
        if let latitude = Double(json[18] as! String),
            let longitude = Double(json[19] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    
    // when used to create an annotation, the location text will be returned as the subtitle for map annotation
    var subtitle: String? {
        return location
    }
    
    
    // returns a pin color depending on the discipline
    var pinTintColor: UIColor  {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture":
            return .purple
        default:
            return .green
        }
    }
    
    
    // annotation info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
