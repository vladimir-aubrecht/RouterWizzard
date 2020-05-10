//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct FirstStartupView: View {
    var body: some View {
            HStack {
                VStack {
                    Text("Please go to Settings to configure router details.").padding().multilineTextAlignment(.center)
                    Button("Go to settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        }
}
