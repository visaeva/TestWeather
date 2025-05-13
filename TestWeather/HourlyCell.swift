//
//  HourlyCell.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 13.05.2025.
//

import UIKit

final class HourlyCell: UICollectionViewCell {
	
	private let timeLabel: UILabel = {
		let label = UILabel()
		label.text = "12:00"
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "cloud.fill")
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private let tempLabel: UILabel = {
		let label = UILabel()
		label.text = "16°C"
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setupUI() {
		contentView.addSubview(timeLabel)
		contentView.addSubview(iconImageView)
		contentView.addSubview(tempLabel)
		contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
		contentView.layer.cornerRadius = 12
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			
			iconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
			iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			iconImageView.widthAnchor.constraint(equalToConstant: 24),
			iconImageView.heightAnchor.constraint(equalToConstant: 24),
			
			tempLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
			tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
}
