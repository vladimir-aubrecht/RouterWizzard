//
//  ServicesClient.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import Foundation
import UIKit

public class ServicesClient
{
    public func fetchServices(onResponse: @escaping (ServiceModel) -> Void) {
        let url = URL(string: "https://raw.githubusercontent.com/vladimir-aubrecht/Tutorials/master/GeoBypass/GeoBypass.json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.parseServices(services: data!, onResponse: onResponse)
        }
        
        task.resume()
    }
    
    private func parseIcon(icon: Data, service: ServicesClientModel, onResponse: @escaping (ServiceModel) -> Void) {
        let image = UIImage(data: icon)
        
        onResponse(ServiceModel(serviceName: service.serviceName, image: image, domains: service.domains))
    }
    
    private func parseServices(services: Data, onResponse: @escaping (ServiceModel) -> Void) {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode([ServicesClientModel].self, from: services)
            
            model.forEach { service in
                
                let task = URLSession.shared.dataTask(with: URL(string: service.iconUrl)!) { (data, response, error) in
                    self.parseIcon(icon: data!, service: service, onResponse: onResponse)
                }
                
                onResponse(ServiceModel(serviceName: service.serviceName, image: nil, domains: service.domains))
                
                task.resume()
            }

         } catch let parsingError {
            print("Error", parsingError)
       }
    }
}
