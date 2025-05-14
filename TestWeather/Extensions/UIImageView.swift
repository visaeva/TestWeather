//
//  UIImageView.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 14.05.2025.
//

import UIKit

extension UIImageView {
	func setImage(from urlString: String) {
		let fullURLString = urlString.hasPrefix("http") ? urlString : "https:\(urlString)"
		guard let url = URL(string: fullURLString) else {
			self.image = nil
			return
		}
		
		if let cachedImage = IconCache.shared.image(for: url) {
			self.image = cachedImage
			return
		}
		
		URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
			guard let data = data,
				  let image = UIImage(data: data),
				  error == nil else { return }
			
			IconCache.shared.save(image: image, for: url)
			DispatchQueue.main.async {
				self?.image = image
			}
		}.resume()
	}
}
