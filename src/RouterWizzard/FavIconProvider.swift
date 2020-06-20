//
//  FavIconProvider.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 20/06/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation
import FavIcon
import UIKit

class FavIconProvider {
    private let defaultIcon : UIImage = UIImage(named: "UnknownDomain")!
    private var icons: [String: UIImage] = [String: UIImage]()
    
    public func refreshFavIcon(domain : String, onRefresh: @escaping (String) -> Void) {
        _ = try! FavIcon.downloadPreferred("https://\(domain)") { result in
            if case let .success(image) = result {
                self.icons.updateValue(image, forKey: domain)
                onRefresh(domain)
            }
        }
    }
    
    public func getFavIcon(domain: String) -> UIImage {
        if let icon = self.icons[domain] {
            return icon
        }
        
        return defaultIcon
    }
}
