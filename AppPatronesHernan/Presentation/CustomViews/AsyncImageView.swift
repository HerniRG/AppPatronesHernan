//
//  AsyncImageView.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class AsyncImageView: UIImageView {
    private var workItem: DispatchWorkItem?
    private var shimmerLayer: CAGradientLayer?

    func setImage(_ string: String) {
        if let url = URL(string: string) {
            setImage(url)
        }
    }

    func setImage(_ url: URL) {

        startShimmer()

        let workItem = DispatchWorkItem {
            let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
            print("Loading image")
            DispatchQueue.main.async { [weak self] in
                self?.stopShimmer()
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
        stopShimmer()
    }

    // Shimmer effect
    private func startShimmer() {
        shimmerLayer = CAGradientLayer()
        shimmerLayer?.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor, UIColor.lightGray.cgColor]
        shimmerLayer?.locations = [0.0, 0.5, 1.0]
        shimmerLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer?.endPoint = CGPoint(x: 1, y: 0.5)
        shimmerLayer?.frame = self.bounds
        self.layer.addSublayer(shimmerLayer!)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        shimmerLayer?.add(animation, forKey: "shimmer")
    }

    private func stopShimmer() {
        shimmerLayer?.removeAllAnimations()
        shimmerLayer?.removeFromSuperlayer()
        shimmerLayer = nil
    }
}
