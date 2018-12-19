/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit


class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var artworks = [Artwork]()
    let locationManager = CLLocationManager()
    
    
    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var regionRadius: CLLocationDistance = 5000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do any additional view setup after this
        
        mapView.delegate = self
        
        //annotationTest()  // we're done testing now that the json is parsed and the array of Artworks is built
        
        loadInitialData()
        mapView.addAnnotations(artworks)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
        centerMapOnLocation(location: locationManager.location ?? initialLocation)
    }
    
    
    
    
    //MARK: JSON Parsing
    // I've never seen json parsing done the way they did it here, it looks efficient
    // loads the data from the json and initializes the Artwork objects, adding them to the "artworks" array
    func loadInitialData() {
        // cracking open that json unless we screw it up somehow
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        // TIL you can use comma separation to guard several different lets
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            // jsons are always set up as dictionaries
            let dictionary = json as? [String: Any],
            // get out our array of arrays of data we're building the objects from
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // turn the array of arrays into a normal array like we need, then finally build the Artwork object and append it to artworks
        let validWorks = works.flatMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
    
    
    //MARK: Location Services
    // asks the user for their location while using the app, and displays it and zooms in on it if they accept
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            // unfortunate swift 3 programming means you have to completely restart the app for this code to run and you to see your location on the map even if you answer yes to the initial prompt
            mapView.showsUserLocation = true
            self.regionRadius = 1000
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // exactly what it says on the tin
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    // ignore this, it's just for initial testing
    // creates a single test artwork when called so we can test the map if we only need to test the features on a single annotation feature
    func annotationTest() {
        let artwork = Artwork(title: "King David Kalakaua",
                              location: "Waikiki Gateway Park",
                              discipline: "Sculpture",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
    }
    
}














