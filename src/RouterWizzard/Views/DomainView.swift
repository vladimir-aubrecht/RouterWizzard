//
//  ContentView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct DomainView: View {
    public let domainModel: DomainModel;
    
    var body: some View {
            HStack {
                Image(uiImage: self.domainModel.image).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(maxWidth: 50, maxHeight: 50)
                Text(self.domainModel.domain)
            }
        }
}
