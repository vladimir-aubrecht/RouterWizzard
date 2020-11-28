//
//  DomainsViewModel.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation
import FavIcon
import UIKit

extension UploadOvpnProfileView {
    class ActionsViewModel : ObservableObject {
        private let actionsClient: UbiquitiActionsClient
        
        init(actionsClient: UbiquitiActionsClient) {
            self.actionsClient = actionsClient
        }
        
        func uploadOvpnProfile(profile: String, username: String, password: String) {
            try! self.actionsClient.uploadOvpnFile(content: profile, username: username, password: password)
        }
    }
}
