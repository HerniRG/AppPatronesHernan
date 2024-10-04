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
        // Utiliza una imagen desenfocada como placeholder
        self.image = getBlurredPlaceholderImage() ?? UIImage(named: "defaultPlaceholder")

        let workItem = DispatchWorkItem {
            let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
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

    // Placeholder desenfocada
    private func getBlurredPlaceholderImage() -> UIImage? {
        guard let placeholder = UIImage(named: "placeholder") else {
            print("Error: La imagen de placeholder no existe.")
            return nil
        }
        
        let context = CIContext(options: nil)
        guard let inputImage = CIImage(image: placeholder), let filter = CIFilter(name: "CIGaussianBlur") else {
            return placeholder
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(10, forKey: kCIInputRadiusKey) // Controla el nivel de desenfoque
        guard let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: inputImage.extent) else {
            return placeholder
        }
        return UIImage(cgImage: cgImage)
    }
}
