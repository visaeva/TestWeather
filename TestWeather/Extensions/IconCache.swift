//
//  IconCache.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 14.05.2025.
//

import UIKit

final class IconCache {
	static let shared = IconCache()
	private let cache = NSCache<NSURL, UIImage>()
	
	func image(for url: URL) -> UIImage? {
		cache.object(forKey: url as NSURL)
	}
	
	func save(image: UIImage, for url: URL) {
		cache.setObject(image, forKey: url as NSURL)
	}
}
