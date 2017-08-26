//
//  CommunicationManager.swift
//  RemoteTracker
//
//  Created by crescenzo garofalo on 19/08/2017.
//  Copyright © 2017 crescenzo garofalo. All rights reserved.
//

import Foundation

class CommunicationManager: NSObject {
    
    
    var remoteTrachkerInput : RemoteTrackerInput
    public static var deviceIdbase64 : String = ""
    static var instance : CommunicationManager = CommunicationManager()
    
    override init() {
        self.remoteTrachkerInput = RemoteTrackerInput()
    }
    
    func sendUserPositionInfo(trackerstatus: Int) {
        debugPrint("sending info to back-end")
        let semaphore = DispatchSemaphore(value: 0)
        
        let json: [String: Any] = ["latitude": self.remoteTrachkerInput.getLatitude(),"longitude":self.remoteTrachkerInput.getLongitude(), "locality":self.remoteTrachkerInput.getLocality(),"trackdate":self.remoteTrachkerInput.getTrackDate(),"trackerStatus":trackerstatus]
        debugPrint("json : \(json)")
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        debugPrint("jsonData : \(jsonData)")
        // create post requests
        let url = URL(string: "http://timetracker.dodifferent.it/TimeTracker/rest/remote-track/")!
        var request = URLRequest(url: url)
        

        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("id", forHTTPHeaderField: CommunicationManager.deviceIdbase64)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        var responseRemoteTracker : [String: Any]? = nil
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                debugPrint(error?.localizedDescription ?? "No data")
                return
            }
            debugPrint("data : \(data)")
            responseRemoteTracker = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            debugPrint("response : \(responseRemoteTracker)")
            //TODO: add code for sending info to BE
            semaphore.signal()
        }
        task.resume()
        
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
    }
}
