//
//  ForecastCollectionViewCell.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 01.03.2023.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    private struct Constant {
        static let temperatureText: (_ model: Day?) -> String = { "\($0?.mintempC ?? 0) / \($0?.maxtempC ?? 0) °С" }
    }
    
    private var weatherImage = UIImageView()
    private var temparatureLabel = UILabel()
    private var dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setup(model: Forecastday?) {
        setupUI()
        
        if let imageUrl = URL(string: model?.day?.condition?.icon?.iconLink ?? "") {
            weatherImage.load(url: imageUrl)
        }
        temparatureLabel.text = Constant.temperatureText(model?.day)
        dateLabel.text = model?.date ?? ""
    }
}

private extension ForecastCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 6
        contentView.addSubview(weatherImage)
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            weatherImage.widthAnchor.constraint(equalToConstant: 30),
            weatherImage.heightAnchor.constraint(equalTo: weatherImage.widthAnchor, multiplier: 1),
            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.addSubview(temparatureLabel)
        temparatureLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        temparatureLabel.textAlignment = .center
        temparatureLabel.minimumScaleFactor = 0.5
        temparatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temparatureLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 8),
            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            temparatureLabel.centerXAnchor.constraint(equalTo: weatherImage.centerXAnchor)
        ])
        
        contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: temparatureLabel.bottomAnchor, constant: 8),
            dateLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - 16),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
