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
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
	private lazy var contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
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
	
	// Почасовой прогноз
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
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
		
		hourlyCollectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
		
	}
	
	private func setupUI() {
		view.addSubview(backgroundImage)
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(cityLabel)
		contentView.addSubview(temperatureLabel)
		contentView.addSubview(weatherDescriptionLabel)
		contentView.addSubview(weatherIcon)
		contentView.addSubview(hourlyCollectionView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			
			cityLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
			cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			
			temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
			temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			
			weatherIcon.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 6),
			weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			weatherIcon.widthAnchor.constraint(equalToConstant: 60),
			weatherIcon.heightAnchor.constraint(equalToConstant: 60),
			
			weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 8),
			weatherDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			weatherDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			
			hourlyCollectionView.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 24),
			hourlyCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			hourlyCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			hourlyCollectionView.heightAnchor.constraint(equalToConstant: 100),
			hourlyCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
			
		])
	}
}




extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 24
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
		return cell
	}
}

