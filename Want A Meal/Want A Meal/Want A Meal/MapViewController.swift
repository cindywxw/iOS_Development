//
//  MapViewController.swift
//  Want A Meal
//
//  Created by Cynthia on 08/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate,UIGestureRecognizerDelegate {

    let restaurantLoc = CLLocationCoordinate2DMake(41.854946, -87.632624)
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var direction: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    // get direction
    @IBAction func getDirection(_ sender: Any) {
        
        if(Reachability.isConnectedToNetwork() == false) {
            showalert(userMessage: "Process interrupted. Not network available. Please try again later.")
            return
        }
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        // get the direction from user current position to the restaurant
        print("get direction")
        self.mapView.showsUserLocation = true
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (locationManager.location?.coordinate)!, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurantLoc, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        print("from: \(request.source!)")
        print("to: \(request.destination!)")
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                print("number of routes found: \(unwrappedResponse.routes.count)")
                
                // add the first route to the mapview
                self.mapView.add(unwrappedResponse.routes[0].polyline)
                let rect = unwrappedResponse.routes[0].polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.direction.center = self.mapView.center
        self.mapView.delegate = self
        self.locationManager.delegate = self

        // Drop a pin for the restaurant
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = restaurantLoc
        dropPin.title = "Address:"
        dropPin.subtitle = "2101 S. China Place, Chicago, IL 60616"
        mapView.addAnnotation(dropPin)
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: restaurantLoc, span: span)
        self.mapView.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5
        return renderer
    }
    // alert
    func showalert(userMessage:String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        print("show alert")
        self.present(myAlert, animated:true, completion:nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// location manager
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        _ = locValue.latitude
//        _ = locValue.longitude
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
