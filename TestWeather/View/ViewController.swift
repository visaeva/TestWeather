//
//  ViewController.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 13.05.2025.
//

import UIKit

final class ViewController: UIViewController {
	private lazy var backgroundImage: UIImageView = {
		let image = UIImageView()
		image.image = UIImage(named: "background")
		image.contentMode = .scaleAspectFill
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	private lazy var cityLabel: UILabel = {
		let label = UILabel()
		label.text = "Moscow"
		label.font = .systemFont(ofSize: 28, weight: .semibold)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var temperatureLabel: UILabel = {
		let label = UILabel()
		label.text = "18°C"
		label.font = .systemFont(ofSize: 55, weight: .light)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var weatherDescriptionLabel: UILabel = {
		let label = UILabel()
		label.text = "Cloudy"
		label.font = .systemFont(ofSize: 18, weight: .regular)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var weatherIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "cloud.sun.fill")
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private lazy var hourlyCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 12
		layout.itemSize = CGSize(width: 70, height: 90)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		return collectionView
	}()
	
	private lazy var weeklyCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 6
		layout.itemSize = CGSize(width: view.frame.width - 40, height: 48)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	private let hourlyData: [(time: String, temp: String, icon: String)] = [
		("12:00", "22.9°C", "cloud.fog.fill"),
		("13:00", "23.1°C", "cloud.fill"),
		("14:00", "23.5°C", "cloud.sun.fill"),
		("15:00", "24.0°C", "sun.max.fill"),
		("16:00", "23.8°C", "cloud.rain.fill"),
		("17:00", "23.6°C", "cloud.fill"),
		("18:00", "23.2°C", "cloud.fog.fill"),
		("19:00", "22.9°C", "cloud.fill"),
		("20:00", "22.7°C", "cloud.sun.fill"),
		("21:00", "22.5°C", "cloud.fog.fill"),
		("22:00", "22.3°C", "cloud.fill"),
		("23:00", "22.1°C", "cloud.rain.fill"),
		("00:00", "22.0°C", "cloud.fog.fill"),
		("01:00", "21.9°C", "cloud.fill"),
		("02:00", "21.8°C", "cloud.sun.fill"),
		("03:00", "21.7°C", "cloud.fog.fill"),
		("04:00", "21.6°C", "cloud.fill"),
		("05:00", "21.5°C", "cloud.rain.fill"),
		("06:00", "21.6°C", "cloud.sun.fill"),
		("07:00", "21.8°C", "sun.max.fill"),
		("08:00", "22.0°C", "cloud.fill"),
		("09:00", "22.3°C", "cloud.fog.fill"),
		("10:00", "22.6°C", "cloud.sun.fill"),
		("11:00", "22.8°C", "cloud.fill")
	]
	
	private let weeklyData: [(date: String, temp: String, condition: String, icon: String)] = [
		("2025-05-14", "22.9°C", "Fog", "cloud.fog.fill"),
		("2025-05-15", "24.0°C", "Cloudy", "cloud.fill"),
		("2025-05-16", "25.5°C", "Sunny", "sun.max.fill"),
		("2025-05-17", "23.8°C", "Rain", "cloud.rain.fill"),
		("2025-05-18", "26.1°C", "Partly Cloudy", "cloud.sun.fill"),
		("2025-05-19", "22.5°C", "Fog", "cloud.fog.fill"),
		("2025-05-20", "24.7°C", "Sunny", "sun.max.fill")
	]
	
	private let networkService = NetworkService()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
		
		hourlyCollectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
		weeklyCollectionView.register(WeeklyCollectionCell.self, forCellWithReuseIdentifier: "WeeklyCollectionCell")
		
		fetchCurrentWeather(lat: 11.7833, lon: 107.2833)
		fetchForecast(lat: 11.7833, lon: 107.2833)
		
	}
	private func fetchCurrentWeather(lat: Double, lon: Double) {
		networkService.fetchCurrentWeather(lat: lat, lon: lon) { result in
			switch result {
			case .success(let response):
				print("Current Weather for \(response.location.name):")
				print("Temperature: \(response.current.tempC)°C")
				print("Condition: \(response.current.condition.text)")
				print("Humidity: \(response.current.humidity)%")
				print("Feels like: \(response.current.feelslikeC)°C")
				print("Last updated: \(response.current.lastUpdated)")
			case .failure(let error):
				print("Error fetching current weather: \(error.localizedDescription)")
			}
		}
	}
	
	private func fetchForecast(lat: Double, lon: Double) {
		networkService.fetchForecast(lat: lat, lon: lon) { result in
			switch result {
			case .success(let response):
				print("\n7-Day Forecast for \(response.location.name):")
				for day in response.forecast.forecastday {
					print("Date: \(day.date)")
					print("Max Temp: \(day.day.maxtempC)°C")
					print("Min Temp: \(day.day.mintempC)°C")
					print("Condition: \(day.day.condition.text)")
					print("Hourly Forecast:")
					for hour in day.hour {
						print("  Time: \(hour.time)")
						print("  Temp: \(hour.tempC)°C")
						print("  Condition: \(hour.condition.text)")
					}
				}
			case .failure(let error):
				print("Error fetching forecast: \(error.localizedDescription)")
			}
		}
	}
	
	private func setupUI() {
		view.addSubview(backgroundImage)
		view.addSubview(cityLabel)
		view.addSubview(temperatureLabel)
		view.addSubview(weatherDescriptionLabel)
		view.addSubview(weatherIcon)
		view.addSubview(hourlyCollectionView)
		view.addSubview(weeklyCollectionView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
			temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			weatherIcon.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 6),
			weatherIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			weatherIcon.widthAnchor.constraint(equalToConstant: 60),
			weatherIcon.heightAnchor.constraint(equalToConstant: 60),
			
			weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 8),
			weatherDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			weatherDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			hourlyCollectionView.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 24),
			hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			hourlyCollectionView.heightAnchor.constraint(equalToConstant: 100),
			
			weeklyCollectionView.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 24),
			weeklyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			weeklyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			weeklyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
		])
	}
}




extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == hourlyCollectionView {
			return hourlyData.count
		} else {
			return weeklyData.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == hourlyCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
			let data = hourlyData[indexPath.item]
			cell.configure(time: data.time, iconName: data.icon, temperature: data.temp)
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCollectionCell", for: indexPath) as! WeeklyCollectionCell
			let data = weeklyData[indexPath.item]
			cell.configure(date: data.date, iconName: data.icon, temperature: data.temp, condition: data.condition)
			return cell
		}
	}
}
