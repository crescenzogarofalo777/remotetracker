//
//  ViewController.swift
//  RemoteTracker
//
//  Created by crescenzo garofalo on 19/08/2017.
//  Copyright © 2017 crescenzo garofalo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var mappingView: MKMapView!
    @IBOutlet weak var exitImageView: UIImageView!
    @IBOutlet weak var deviceIdLabel: UILabel!
    
    var positionManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    @IBOutlet weak var positionLabel: UILabel!
    
    var renderedMap: Bool = false
    var loadedMap: Bool = false
    var regionChanged: Bool = false
    var annotationLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mappingView.delegate = self
        self.positionManager = CLLocationManager()
        self.positionManager.delegate = self
        self.positionManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.positionManager.requestWhenInUseAuthorization()
        self.positionManager.distanceFilter = 5
        self.positionManager.startUpdatingLocation()
        deviceIdLabel.text! = "Device ID: \(UIDevice.current.identifierForVendor!.uuidString)"
        positionLabel.text! = "Ricerca posizione in corso..."
        
        let tapEntry = UITapGestureRecognizer(target: self, action: #selector(sendButtonsTapped(sender:)))
        let tapExit = UITapGestureRecognizer(target: self, action: #selector(sendButtonsTapped(sender:)))
        self.entryImageView.addGestureRecognizer(tapEntry)
        self.exitImageView.addGestureRecognizer(tapExit)
        self.entryImageView.isUserInteractionEnabled = true
        self.exitImageView.isUserInteractionEnabled = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userPosition = manager.location?.coordinate
        //debugPrint("posizione aggiornata : lat : \(self.userPosition.latitude) - lon : \(self.userPosition.longitude)")
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: self.userPosition, span: span)
        self.mappingView.setRegion(region, animated: true)
        
        self.mappingView.showsUserLocation = true
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        debugPrint("mapViewDidFinishRenderingMap")
        self.renderedMap = true
        self.updatePositionLabel()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        debugPrint("mapViewDidFinishLoadingMap")
        self.loadedMap = true
        self.updatePositionLabel()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        debugPrint("mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)")
        self.regionChanged = true
        self.updatePositionLabel()
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        debugPrint("mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView])")
        self.annotationLoaded = true
        self.updatePositionLabel()
    }
    
    func updatePositionLabel() {
        if (renderedMap && loadedMap && regionChanged && annotationLoaded) {
            positionLabel.text! = "lat : \(String(format: "%.2f",self.userPosition.latitude)) - lon : \(String(format: "%.2f",self.userPosition.longitude))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sendButtonsTapped(sender: UITapGestureRecognizer) {
        if sender.view == entryImageView {
            debugPrint("tapped entry button")
        } else if sender.view == exitImageView {
            debugPrint("tapped exit button")
        }
    }
}

