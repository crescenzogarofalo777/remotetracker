//
//  RemoteTrackerInput.swift
//  RemoteTracker
//
//  Created by crescenzo garofalo on 26/08/2017.
//  Copyright © 2017 crescenzo garofalo. All rights reserved.
//

import Foundation

class RemoteTrackerInput {
    
    private var latitude : Double
    
    private var longitude : Double
    
    private var locality : String
    
    private var trackDate : String

    private var trackerStatus : Int
    
    public init() {
        self.latitude = 0.0
        self.longitude = 0.0
        self.locality = ""
        self.trackDate = ""
        self.trackerStatus = -1
    }
    
    public func getLatitude() -> Double {
        return self.latitude
    }
    
    public func setLatitude(latitude : Double) {
        self.latitude = latitude
    }

    public func getLongitude() -> Double {
        return self.longitude
    }
    
    public func setLongitude(longitude : Double) {
        self.longitude = longitude
    }

    public func getLocality() -> String {
        return self.locality
    }
    
    public func setLocality(locality : String) {
        self.locality = locality
    }

    public func getTrackDate() -> String {
        return self.trackDate
    }
    
    public func setTrackDate(trackDate : String) {
        self.trackDate = trackDate
    }

    public func getTrackerStatus() -> Int {
        return self.trackerStatus
    }
    
    public func setLatitude(trackerStatus : Int) {
        self.trackerStatus = trackerStatus
    }

}
