//
//  ViewController.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 13.05.2025.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController, CLLocationManagerDelegate {
	// MARK: - Properties
	private let locationManager: CLLocationManager = CLLocationManager()
	private var hourlyData: [HourWeather] = []
	private var weeklyData: [ForecastDay] = []
	private var currentWeather: CurrentWeatherResponse?
	private var forecast: ForecastWeatherResponse?
	
	private let networkService = NetworkService()
	
	private lazy var backgroundImage: UIImageView = {
		let image = UIImageView()
		image.image = UIImage(named: "background")
		image.contentMode = .scaleAspectFill
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	private lazy var cityLabel: UILabel = {
		let label = UILabel()
		label.text = "Загружаю..."
		label.font = .systemFont(ofSize: 28, weight: .semibold)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var temperatureLabel: UILabel = {
		let label = UILabel()
		label.text = "--°C"
		label.font = .systemFont(ofSize: 55, weight: .light)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var weatherDescriptionLabel: UILabel = {
		let label = UILabel()
		label.text = "Загружаю..."
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
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.style = .large
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.hidesWhenStopped = true
		activityIndicator.color = .white
		activityIndicator.startAnimating()
		return activityIndicator
	}()
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
		
		hourlyCollectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
		weeklyCollectionView.register(WeeklyCollectionCell.self, forCellWithReuseIdentifier: "WeeklyCollectionCell")
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
	// MARK: - UI Setup
	private func setupUI() {
		view.addSubview(backgroundImage)
		view.addSubview(cityLabel)
		view.addSubview(temperatureLabel)
		view.addSubview(weatherDescriptionLabel)
		view.addSubview(weatherIcon)
		view.addSubview(hourlyCollectionView)
		view.addSubview(weeklyCollectionView)
		view.addSubview(activityIndicator)
	}
	
	private func updateUI() {
		hourlyCollectionView.reloadData()
		weeklyCollectionView.reloadData()
		activityIndicator.stopAnimating()
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
			weeklyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	// MARK: - Network Requests
	private func fetchWeatherForMoscow() {
		let moscowLat = 55.7558
		let moscowLon = 37.6173
		cityLabel.text = "Москва"
		fetchCurrentWeather(lat: moscowLat, lon: moscowLon)
		fetchForecast(lat: moscowLat, lon: moscowLon)
	}
	
	private func fetchCurrentWeather(lat: Double, lon: Double) {
		Task {
			do {
				let response = try await networkService.fetchCurrentWeather(lat: lat, lon: lon)
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.currentWeather = response
					self.cityLabel.text = response.location.name
					self.temperatureLabel.text = "\(Int(response.current.tempC))°C"
					self.weatherDescriptionLabel.text = response.current.condition.text
					let iconPath = response.current.condition.icon
					self.weatherIcon.setImage(from: iconPath)
					self.activityIndicator.stopAnimating()
				}
			} catch {
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.cityLabel.text = "Неизвестно"
					self.temperatureLabel.text = "--°C"
					self.activityIndicator.stopAnimating()
					self.showErrorAlert(lat: lat, lon: lon)
				}
			}
		}
	}
	
	private func fetchForecast(lat: Double, lon: Double) {
		Task {
			do {
				let response = try await networkService.fetchForecast(lat: lat, lon: lon)
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.forecast = response
					self.hourlyData = response.forecast.forecastday.count >= 2 ? self.filterHourlyData(from: response.forecast.forecastday) : []
					self.weeklyData = response.forecast.forecastday
					self.updateUI()
				}
			} catch {
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.hourlyData = []
					self.weeklyData = []
					self.updateUI()
					self.showErrorAlert(lat: lat, lon: lon)
				}
			}
		}
	}
	
	private func filterHourlyData(from forecastDays: [ForecastDay]) -> [HourWeather] {
		let now = Date()
		let calendar = Calendar.current
		let currentHour = calendar.component(.hour, from: now)
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		let currentDateString = formatter.string(from: now)
		
		var filteredData: [HourWeather] = []
		
		if let today = forecastDays.first {
			let todayHours = today.hour.filter { hour in
				guard let hourDate = formatter.date(from: String(hour.time.split(separator: " ").first ?? "")),
					  let hourString = hour.time.split(separator: " ").last,
					  let hourValue = Int(hourString.split(separator: ":").first ?? "0") else {
					return false
				}
				return formatter.string(from: hourDate) == currentDateString && hourValue >= currentHour
			}
			filteredData.append(contentsOf: todayHours)
		}
		
		if forecastDays.count > 1 {
			filteredData.append(contentsOf: forecastDays[1].hour)
		}
		
		return filteredData
	}
	// MARK: - Alert
	private func showErrorAlert(lat: Double, lon: Double) {
		let alert = UIAlertController(
			title: "Ошибка",
			message: "Не удалось загрузить данные. Попробовать снова?",
			preferredStyle: .alert
		)
		
		let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
			self?.activityIndicator.startAnimating()
			self?.fetchCurrentWeather(lat: lat, lon: lon)
			self?.fetchForecast(lat: lat, lon: lon)
		}
		
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
		
		alert.addAction(retryAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true)
	}
	
	// MARK: - CLLocationManagerDelegate
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.last else {
			fetchWeatherForMoscow()
			return
		}
		
		if currentLocation.horizontalAccuracy > 0 {
			locationManager.stopUpdatingLocation()
			let latitude = currentLocation.coordinate.latitude
			let longitude = currentLocation.coordinate.longitude
			fetchCurrentWeather(lat: latitude, lon: longitude)
			fetchForecast(lat: latitude, lon: longitude)
		} else {
			fetchWeatherForMoscow()
		}
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		let status = manager.authorizationStatus
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			locationManager.startUpdatingLocation()
		case .denied, .restricted:
			fetchWeatherForMoscow()
		case .notDetermined:
			break
		@unknown default:
			fetchWeatherForMoscow()
		}
	}
}
// MARK: - UICollectionView methods
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
			let time = data.time.split(separator: " ").last ?? ""
			cell.configure(
				time: String(time),
				iconUrl: data.condition.icon,
				temperature: "\(Int(data.tempC))°C"
			)
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCollectionCell", for: indexPath) as! WeeklyCollectionCell
			let data = weeklyData[indexPath.item]
			cell.configure(
				date: data.date,
				iconUrl: data.day.condition.icon,
				temperature: "\(Int(data.day.maxtempC))°C",
				condition: data.day.condition.text
			)
			return cell
		}
	}
}
