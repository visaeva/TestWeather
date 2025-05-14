//
//  ViewController.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 13.05.2025.
//

import UIKit

final class ViewController: UIViewController {
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
		
		hourlyCollectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
		weeklyCollectionView.register(WeeklyCollectionCell.self, forCellWithReuseIdentifier: "WeeklyCollectionCell")
		
		fetchCurrentWeather(lat: 11.7833, lon: 107.2833)
		fetchForecast(lat: 11.7833, lon: 107.2833)
		
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
	
	private func fetchCurrentWeather(lat: Double, lon: Double) {
		networkService.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self else { return }
				switch result {
				case .success(let response):
					self.currentWeather = response
					self.cityLabel.text = response.location.name
					self.temperatureLabel.text = "\(response.current.tempC)°C"
					self.weatherDescriptionLabel.text = response.current.condition.text
					let iconPath = response.current.condition.icon
					self.weatherIcon.setImage(from: iconPath)
					
				case .failure:
					self.cityLabel.text = "Error"
					self.temperatureLabel.text = "--°C"
				}
			}
		}
	}
	
	private func fetchForecast(lat: Double, lon: Double) {
		networkService.fetchForecast(lat: lat, lon: lon) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					self?.forecast = response
					self?.hourlyData = response.forecast.forecastday.first?.hour ?? []
					self?.weeklyData = response.forecast.forecastday
					self?.hourlyCollectionView.reloadData()
					self?.weeklyCollectionView.reloadData()
					
				case .failure:
					self?.hourlyData = []
					self?.weeklyData = []
					self?.hourlyCollectionView.reloadData()
					self?.weeklyCollectionView.reloadData()
				}
			}
		}
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
			let time = data.time.split(separator: " ").last ?? ""
			cell.configure(
				time: String(time),
				iconUrl: data.condition.icon,
				temperature: "\(data.tempC)°C"
			)
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCollectionCell", for: indexPath) as! WeeklyCollectionCell
			let data = weeklyData[indexPath.item]
			cell.configure(
				date: data.date,
				iconUrl: data.day.condition.icon,
				temperature: "\(data.day.maxtempC)°C",
				condition: data.day.condition.text
			)
			return cell
		}
	}
}
