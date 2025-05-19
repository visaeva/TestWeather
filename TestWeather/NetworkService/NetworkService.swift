//
//  NetworkService.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 14.05.2025.
//

import Foundation

enum NetworkError: Error {
	case invalidURL
	case decodingError
	case dataError
}
class NetworkService {
	private let apiKey = "fa8b3df74d4042b9aa7135114252304"
	private let baseURL = "https://api.weatherapi.com/v1"
	
	func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherResponse {
		let urlString = "\(baseURL)/current.json?key=\(apiKey)&q=\(lat),\(lon)"
		guard let url = URL(string: urlString) else {
			throw NetworkError.invalidURL
		}
		let data = try await URLSession.shared.data(from: url).0
		
		guard !data.isEmpty else {
			throw NetworkError.dataError
		}
		
		do {
			let decoder = JSONDecoder()
			let response = try decoder.decode(CurrentWeatherResponse.self, from: data)
			return response
		} catch {
			throw NetworkError.decodingError
		}
	}
	
	func fetchForecast(lat: Double, lon: Double, days: Int = 7) async throws -> ForecastWeatherResponse {
		let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=\(days)"
		guard let url = URL(string: urlString) else {
			throw NetworkError.invalidURL
		}
		let data = try await URLSession.shared.data(from: url).0
		
		guard !data.isEmpty else {
			throw NetworkError.dataError
		}
		
		do {
			let decoder = JSONDecoder()
			let response = try decoder.decode(ForecastWeatherResponse.self, from: data)
			return response
		} catch {
			throw NetworkError.decodingError
		}
	}
	
	func startFetchingData(latitude: Double, longitude: Double) async throws -> (ForecastWeatherResponse, CurrentWeatherResponse) {
		async let currentWeather = fetchCurrentWeather(lat: latitude, lon: longitude)
		async let forecast = fetchForecast(lat: latitude, lon: longitude)
		
		return try await (forecast, currentWeather)
	}
}
