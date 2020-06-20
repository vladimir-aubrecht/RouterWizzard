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
    
    init() {
        self.loadImagesFromDisk()
    }
    
    public func refreshFavIcon(domain : String, onRefresh: @escaping (String) -> Void) {
        _ = try! FavIcon.downloadPreferred("https://\(domain)") { result in
            if case let .success(image) = result {
                self.saveImage(imageName: domain, image: image)
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
    
    private func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }

    private func loadImagesFromDisk() {
        let imagesUrls = searchImagesFromDisk()
        
        for imageUrl in imagesUrls! {
            let image = UIImage(contentsOfFile: imageUrl.path)
            self.icons.updateValue(image!, forKey: imageUrl.lastPathComponent)
        }
    }
    
    private func searchImagesFromDisk() -> [URL]?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let dirPath = paths.first {
            return try! FileManager.default.contentsOfDirectory(at: dirPath, includingPropertiesForKeys: nil)
        }
        
        return nil
    }
}
