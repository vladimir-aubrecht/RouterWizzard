//
//  OvpnDocumentPickerView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 28.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

final class OvpnDocumentPickerView: NSObject, UIViewControllerRepresentable {
    let onPick: (String) -> Void
    
    init(onPick: @escaping (String) -> Void) {
        self.onPick = onPick
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        documentPicker.delegate = self
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }
}

extension OvpnDocumentPickerView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count > 0 {
            DispatchQueue.main.async {
                let url = urls[0]
                do {
                    let data = try Data(contentsOf: url)
                    self.onPick(String(decoding: data, as: UTF8.self))
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true) {
            print("Picker cancelled")
        }
    }
}
