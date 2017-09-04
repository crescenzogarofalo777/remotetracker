//
//  ViewController.swift
//  RemoteTracker
//
//  Created by crescenzo garofalo on 19/08/2017.
//  Copyright © 2017 crescenzo garofalo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBAction func refreshAction(_ sender: UIButton) {
        
        sender.pulse()
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            
        })
        UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseIn, animations: { () -> Void in
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            
        })
        
        self.positionManager.stopUpdatingLocation()
        self.positionManager.startUpdatingLocation()
    }

    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var mappingView: MKMapView!
    @IBOutlet weak var exitImageView: UIImageView!
    @IBOutlet weak var deviceIdLabel: UILabel!
    
    var positionManager: CLLocationManager!
    var geoCoder : CLGeocoder!
    var userPosition: CLLocation!
    @IBOutlet weak var positionLabel: UILabel!
    
    var renderedMap: Bool = false
    var loadedMap: Bool = false
    var regionChanged: Bool = false
    var annotationLoaded: Bool = false
    var tapGesturesAdded = false
    

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
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let strData = (deviceId).data(using: String.Encoding.utf8)
        CommunicationManager.deviceIdbase64 = strData!.base64EncodedString()

        
        self.deviceIdLabel.text! = "Device ID: \(deviceId)"
        self.positionLabel.text! = "Ricerca posizione in corso..."
        self.entryImageView.tintColor = UIColor.gray
        self.exitImageView.tintColor = UIColor.gray
        self.entryImageView.isUserInteractionEnabled = true
        self.exitImageView.isUserInteractionEnabled = true
        self.geoCoder = CLGeocoder()
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userPosition = manager.location
        
        if !tapGesturesAdded && self.userPosition.coordinate.latitude != 0 && self.userPosition.coordinate.longitude != 0 {
            self.entryImageView.tintColor = UIColor.black
            self.exitImageView.tintColor = UIColor.black
            let tapEntry = UITapGestureRecognizer(target: self, action: #selector(sendButtonsTapped(sender:)))
            let tapExit = UITapGestureRecognizer(target: self, action: #selector(sendButtonsTapped(sender:)))
            self.entryImageView.addGestureRecognizer(tapEntry)
            self.exitImageView.addGestureRecognizer(tapExit)
            self.tapGesturesAdded = true
        }
        
        //debugPrint("posizione aggiornata : lat : \(self.userPosition.latitude) - lon : \(self.userPosition.longitude)")
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: self.userPosition.coordinate, span: span)
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
            
            
            CommunicationManager.instance.remoteTrachkerInput.setLatitude(latitude: self.userPosition.coordinate.latitude)
            CommunicationManager.instance.remoteTrachkerInput.setLongitude(longitude: self.userPosition.coordinate.longitude)
            //CommunicationManager.instance.remoteTrachkerInput.setLocality(locality: <#T##String#>)
            if self.userPosition.coordinate.latitude != 0 && self.userPosition.coordinate.longitude != 0 {
                self.geoCoder.reverseGeocodeLocation(self.userPosition ) { placemarks, error in
                
                    guard let addressDict = placemarks?[0].addressDictionary else {
                        return
                    }
                
                    let streetAddress = addressDict["Name"] as! String
                    let city = addressDict["City"] as! String
                    let locality = streetAddress + " " + city
                    CommunicationManager.instance.remoteTrachkerInput.setLocality(locality: locality)
                    self.positionLabel.text! = locality

                }
            }
            
            CommunicationManager.instance.remoteTrachkerInput.setTrackDate(trackDate: formatCurrentDate())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sendButtonsTapped(sender: UITapGestureRecognizer) {
        let currentDate = formatCurrentDate()
        debugPrint("current date : \(currentDate)")
        CommunicationManager.instance.remoteTrachkerInput.setTrackDate(trackDate: currentDate)
        let alertTitle : String = "Remote tracker"
        var messageTitle : String = ""
        var trackerStatus = -1
        if sender.view == entryImageView {
            debugPrint("tapped entry button")
            trackerStatus = 1
        } else if sender.view == exitImageView {
            debugPrint("tapped exit button")
            trackerStatus = 0
        }
        let statusCode = CommunicationManager.instance.sendUserPositionInfo(trackerStatus: trackerStatus)
        if statusCode == -1 || statusCode == 500 {
            messageTitle = "Internal Server Error"
        } else if statusCode == 401 || statusCode == 412 {
            messageTitle = "Utente non autorizzato"
        } else if statusCode == 400 {
            messageTitle = "Richiesta errata"
        } else if statusCode != 200 {
            messageTitle = "Problemi di comunicazione"
        } else {
            messageTitle = "Evento inviato con successo"
        }
        
        let alert = UIAlertController(title: alertTitle,
                                      message: messageTitle,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func formatCurrentDate() -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = Date()
        return formatter.string(from: date) + "+0200"
    }
}

