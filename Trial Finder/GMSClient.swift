//
//  GMSClient.swift
//  Trial Finder
//
//  Created by Huynh Danh on 1/2/17.
//  Copyright © 2017 Iran Mateu. All rights reserved.
//

import Foundation
import CoreLocation

class GMSClient {
    
    let baseUrl = "http://maps.googleapis.com/maps/api/geocode/json?address={zipcode}&sensor=true"
    
    let session = URLSession.shared
    
    static let shared = GMSClient()
    
    private init() {}
    
    func getLocation(zipcode: String, countryCode: String, completion: @escaping (_ location: CLLocation?, _ error: NSError?) -> Void) {
        
        let urlString = baseUrl.replacingOccurrences(of: "{zipcode}", with: zipcode)
        
        taskForGETMethod(urlString: urlString) { (data, error) in
            
            func sendError(message: String) {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
            
            if let error = error {
                print("error: \(error.localizedDescription)")
                sendError(message: error.localizedDescription)
                return
            }
            
            guard let data = data else {
                sendError(message: "No data returned")
                return
            }
            
            var parsedResult: [String: AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch let error as NSError {
                print(error.localizedDescription)
                sendError(message: error.localizedDescription)
                return
            }
            
            guard let results = parsedResult["results"] as? [[String: AnyObject]], results.count > 0 else {
                sendError(message: "Could not find the key `results`!")
                return
            }
            
            guard let addressComponents = results.first?["address_components"] as? [[String: AnyObject]], let code = addressComponents.last?["short_name"] as? String, code == countryCode else {
                sendError(message: "Could not find \(zipcode) in \(countryCode)!")
                return
            }
            
            guard let geometry = results.first?["geometry"] as? [String: AnyObject] else {
                sendError(message: "Could not find the key `geometry`!")
                return
            }
            
            guard let location = geometry["location"] as? [String: AnyObject] else {
                sendError(message: "Could not find the key `location`!")
                return
            }
            
            guard let lat = location["lat"] as? Double, let lng = location["lng"] as? Double else {
                sendError(message: "Could not find the key `lat` & `lng`!")
                return
            }
            
            completion(CLLocation(latitude: lat, longitude: lng), nil)
        }
    }
    
    func taskForGETMethod(urlString: String, completion: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            func sendError(message: String) {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
            
            if let error = error {
                sendError(message: error.localizedDescription)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 && statusCode > 299 {
                sendError(message: "The task returned a statusCode other than 2xx")
                return
            }
            
            guard let data = data else {
                sendError(message: "No data returned")
                return
            }
            
            completion(data, nil)
        }
        
        task.resume()
    }
}
