//
//  ServiceView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ServiceView: View {
    @ObservedObject private var serviceModelView:ServiceModelView
    private var editServiceModelView:EditServiceModelView
    
    init(serviceModelView: ServiceModelView, editServiceModelView: EditServiceModelView) {
        self.serviceModelView = serviceModelView
        self.editServiceModelView = editServiceModelView
    }
    
    var body: some View {
        VStack {
            let services = self.serviceModelView.getServices()
            
                if services.isEmpty {
                    Text("Loading...")
                }
                else {
                    NavigationView {
                        List {
                            ForEach(services, id: \.name) { service in
                                NavigationLink(destination: EditServiceView(serviceModel: service, editServiceModelView: self.editServiceModelView)) {
                                    HStack(alignment: .top) {
                                        Image(uiImage: service.image).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(maxWidth: 150, maxHeight: 150)
                                        VStack(alignment: .leading) {
                                            Text("Location: " + service.location).padding(3)
                                            Text("Status: " + service.status).padding(3)
                                        }
                                    }
                                }
                           }
                        }
                }
            }
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(serviceModelView: ServiceModelView(routerProvider: EmptyRouterProvider()), editServiceModelView: EditServiceModelView(routerProvider: EmptyRouterProvider()))
    }
}
