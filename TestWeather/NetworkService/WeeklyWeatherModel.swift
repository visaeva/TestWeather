//
//  WeeklyWeatherModel.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 14.05.2025.
//

import Foundation

struct ForecastWeatherResponse: Codable {
	let location: Location
	let forecast: Forecast
	
}

struct Forecast: Codable {
	let forecastday: [ForecastDay]
}


struct ForecastDay: Codable {
	let date: String
	let day: DayWeather
	let hour: [HourWeather]
	
}

struct DayWeather: Codable {
	let maxtempC: Double
	let mintempC: Double
	let condition: WeatherCondition
	
	enum CodingKeys: String, CodingKey {
		case maxtempC = "maxtemp_c"
		case mintempC = "mintemp_c"
		case condition
	}
}

struct HourWeather: Codable {
	let time: String
	let tempC: Double
	let condition: WeatherCondition
	let windKph: Double?
	let humidity: Int?
	let precipMm: Double?
	
	enum CodingKeys: String, CodingKey {
		case time
		case tempC = "temp_c"
		case condition
		case windKph = "wind_kph"
		case humidity
		case precipMm = "precip_mm"
	}
}
