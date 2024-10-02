//
//  AsyncImageView.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class AsyncImageView: UIImageView {
    private var workItem: DispatchWorkItem?
    
    func setImage(_ string: String) {
        if let url = URL(string: string) {
            setImage(url)
        }
    }
    
    func setImage(_ url: URL) {
        let workItem = DispatchWorkItem {
            let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
            print("Loading image")
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.workItem = nil
            }
        }
        DispatchQueue.global().async(execute: workItem)
        self.workItem = workItem
    }
    
    func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
