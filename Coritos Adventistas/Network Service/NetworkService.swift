//
//  NetworkService.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 9/10/21.
//  Copyright © 2021 Jose Pimentel. All rights reserved.
//

import UIKit

class NetworkService {
    
    //static let shared = NetworkService()
    
    var trackTime: String = ""
    var trackDuration = 0
    var trackName: String = ""
    var index = Int()
    let apiURL = "https://audius-metadata-4.figment.io/v1/playlists/DE3wQ/tracks?app_name=coritosAdventistas"
    
    
    //performRequest(apiURL)
    
    func performRequest(i: Int) {
        
        index = i
        
        if let url = URL(string: apiURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    
                    self.parseJSON(apiData: safeData)
                    //let dataString = String(data: safeData, encoding: .utf8)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(apiData: Data)  {
        
        let decoder = JSONDecoder()
        do {
            
            let decoderData = try decoder.decode(DataAPI.self, from: apiData)
            
            //convert the time
            //let hours = Int(decoderData.data[1].duration) / 3600
            let minutes = Int(decoderData.data[index].duration) / 60 % 60
            let seconds = Int(decoderData.data[1].duration) % 60
            
            //print(decoderData.data[1].duration)
            
            //print(String(format:"%02i:%02i", minutes, seconds))
            //print(decoderData.data[CoritosViewController.indexCoritoApi].title)
            
            trackTime = String(format:"%02i:%02i", minutes, seconds)
            //print(trackTime)
            trackName = decoderData.data[index].id
        
            trackDuration = decoderData.data[index].duration
            
        } catch {
            
            print(error)
        }
        
        
    }
    
//    func getHimnoTime() -> String {
//
//
//        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
//    }
}

