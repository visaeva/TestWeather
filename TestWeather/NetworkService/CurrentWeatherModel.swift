//
//  WeatherModel.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 14.05.2025.
//

import Foundation

struct CurrentWeatherResponse: Codable {
	let location: Location
	let current: CurrentWeather
}

struct Location: Codable {
	let name: String
	let region: String
	let country: String
	let lat: Double
	let lon: Double
	let tzId: String?
	let localtimeEpoch: Int?
	let localtime: String
	
	enum CodingKeys: String, CodingKey {
		case name, region, country, lat, lon
		case tzId = "tz_id"
		case localtimeEpoch = "localtime_epoch"
		case localtime
	}
}

struct CurrentWeather: Codable {
	let lastUpdated: String
	let tempC: Double
	let tempF: Double?
	let isDay: Int?
	let condition: WeatherCondition
	let windKph: Double
	let humidity: Int
	let feelslikeC: Double
	let precipMm: Double?
	let uv: Double?
	
	enum CodingKeys: String, CodingKey {
		case lastUpdated = "last_updated"
		case tempC = "temp_c"
		case tempF = "temp_f"
		case isDay = "is_day"
		case condition
		case windKph = "wind_kph"
		case humidity
		case feelslikeC = "feelslike_c"
		case precipMm = "precip_mm"
		case uv
	}
}

struct WeatherCondition: Codable {
	let text: String
	let icon: String
	let code: Int
}
