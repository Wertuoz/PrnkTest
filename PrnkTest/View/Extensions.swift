//
//  Extensions.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

// clears view
extension UIView {
    func removeAllSubView() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIView {
    func addView(_ view: UIView) {
        self.addSubview(view)
        self.subviews.forEach { $0.isUserInteractionEnabled = true }
    }
}

// Extension to load image
extension UIImageView {
    func loadImage(fromUrl: String) {
        guard let imageUrl = URL(string: fromUrl) else {
            return
        }
        let cache = URLCache.shared
        let request = URLRequest(url: imageUrl)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.transition(toImage: image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transition(toImage: image)
                        }
                    }
                }).resume()
            }
        }
    }
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.image = image
        }, completion: nil)
    }
}
