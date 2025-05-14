//
//  WeeklyTableView.swift
//  TestWeather
//
//  Created by Victoria Isaeva on 13.05.2025.
//

import UIKit

final class WeeklyCollectionCell: UICollectionViewCell {
	
	private let dateLabel: UILabel = {
		let label = UILabel()
		label.text = "2025-05-14"
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "cloud.fog.fill")
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private let tempLabel: UILabel = {
		let label = UILabel()
		label.text = "22.9°C"
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let conditionLabel: UILabel = {
		let label = UILabel()
		label.text = "Fog"
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = .white
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
		contentView.addSubview(dateLabel)
		contentView.addSubview(iconImageView)
		contentView.addSubview(tempLabel)
		contentView.addSubview(conditionLabel)
		contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
		contentView.layer.cornerRadius = 12
		contentView.layer.masksToBounds = true
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			conditionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			tempLabel.trailingAnchor.constraint(equalTo: conditionLabel.leadingAnchor, constant: -8),
			tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			iconImageView.trailingAnchor.constraint(equalTo: tempLabel.leadingAnchor, constant: -8),
			iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			iconImageView.widthAnchor.constraint(equalToConstant: 24),
			iconImageView.heightAnchor.constraint(equalToConstant: 24)
		])
	}
	
	func configure(date: String, iconUrl: String, temperature: String, condition: String) {
		dateLabel.text = date
		conditionLabel.text = condition
		tempLabel.text = temperature
		iconImageView.setImage(from: iconUrl)
	}
	
}
