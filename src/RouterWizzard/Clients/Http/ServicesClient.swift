//
//  ServicesClient.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public class ServicesClient: ObservableObject
{
    @Published public var serviceCollection: [ServiceModel]?
    
    public func fetchServices() {
        let url = URL(string: "https://raw.githubusercontent.com/vladimir-aubrecht/Tutorials/master/GeoBypass/GeoBypass.json")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do{
                    let decoder = JSONDecoder()
                    let model = try decoder.decode([ServiceModel].self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.serviceCollection = model
                    }
                 } catch let parsingError {
                    print("Error", parsingError)
               }
            }
        task.resume()
    }
}
