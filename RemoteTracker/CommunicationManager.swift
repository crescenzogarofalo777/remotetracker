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
    
    func sendUserPositionInfo(trackerStatus: Int) -> Int {
        debugPrint("sending info to back-end")
        var statusCode = -1
        let semaphore = DispatchSemaphore(value: 0)
        
        let json: [String: Any] = ["latitude": "\(self.remoteTrachkerInput.getLatitude())","longitude":"\(self.remoteTrachkerInput.getLongitude())", "locality":"\(self.remoteTrachkerInput.getLocality())","trackdate":"\(self.remoteTrachkerInput.getTrackDate())","trackerStatus":trackerStatus]
        debugPrint("json : \(json)")
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        debugPrint("jsonData : \(jsonData!)")

        // create post requests
        let url = URL(string: "http://timetracker.dodifferent.it/TimeTracker/rest/remote-track/")!
        var request = URLRequest(url: url)
        

        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(CommunicationManager.deviceIdbase64, forHTTPHeaderField: "id")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData!
        var responseRemoteTracker : [String: Any]? = nil
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                debugPrint(error?.localizedDescription ?? "No data")
                return
            }
            
            if let httpresponse = response as? HTTPURLResponse {
                statusCode = httpresponse.statusCode
                debugPrint("status code : \(httpresponse.statusCode)")
            }
            responseRemoteTracker = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            debugPrint("response : \(responseRemoteTracker)")
            //TODO: add code for sending info to BE
            semaphore.signal()
        }
        task.resume()
        
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return statusCode
        
    }
}
