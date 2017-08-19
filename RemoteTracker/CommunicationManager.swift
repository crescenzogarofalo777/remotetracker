//
//  CommunicationManager.swift
//  RemoteTracker
//
//  Created by crescenzo garofalo on 19/08/2017.
//  Copyright © 2017 crescenzo garofalo. All rights reserved.
//

import Foundation

class CommunicationManager: NSObject {
    
    static var instance : CommunicationManager = CommunicationManager()
    
    func sendUserPositionInfo(latitude: Double, longitude: Double) {
        debugPrint("sending info to back-end")
        /*let semaphore = DispatchSemaphore(value: 0)
        
        let json: [String: Any] = ["latitude": latitude,"longitude":longitude]
        debugPrint("json : \(json)")
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        debugPrint("jsonData : \(jsonData)")
        // create post requests
        let url = URL(string: "http://perudo-gcgame.rhcloud.com/jersey/login")!
        var request = URLRequest(url: url)
        
        
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        var responseRemoteTracker : [String: Any]? = nil
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                debugPrint(error?.localizedDescription ?? "No data")
                return
            }
            responseRemoteTracker = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            //TODO: add code for sending info to BE
            semaphore.signal()
        }
        task.resume()
        
        
        semaphore.wait(timeout: DispatchTime.distantFuture)*/
        
    }
}
