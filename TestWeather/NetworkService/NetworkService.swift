//
//  NetworkService.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 14.05.2025.
//

import Foundation

class NetworkService {
	private let apiKey = "fa8b3df74d4042b9aa7135114252304"
	private let baseURL = "https://api.weatherapi.com/v1"
	
	func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void) {
		let urlString = "\(baseURL)/current.json?key=\(apiKey)&q=\(lat),\(lon)"
		guard let url = URL(string: urlString) else {
			completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let weatherResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
				completion(.success(weatherResponse))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
	
	func fetchForecast(lat: Double, lon: Double, days: Int = 7, completion: @escaping (Result<ForecastWeatherResponse, Error>) -> Void) {
		let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=\(days)"
		guard let url = URL(string: urlString) else {
			completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let forecastResponse = try decoder.decode(ForecastWeatherResponse.self, from: data)
				completion(.success(forecastResponse))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}
