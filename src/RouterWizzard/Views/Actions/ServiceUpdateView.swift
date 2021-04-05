//
//  ContentView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ServiceUpdateView: View {
    private let serviceModel: ServiceModel
    
    init(serviceModel: ServiceModel) {
        self.serviceModel = serviceModel
    }
    
    var body: some View {
        if serviceModel.image != nil {
            Image(uiImage: serviceModel.image!).resizable().aspectRatio(contentMode: .fit).scaledToFit()
        }
        else {
            Text(serviceModel.serviceName)
        }
        Spacer()
        
        Button(action: {
                                                
        }){
            Text("Activate")
        }
        .padding(10)
        .foregroundColor(.white)
        .background(Color.green)
        .cornerRadius(5)
        
        Spacer()
    }
}
