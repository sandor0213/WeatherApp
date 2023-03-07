//
//  ForecastViewController.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 01.03.2023.
//

import UIKit

final class ForecastViewController: UIViewController {
    
    private var forecastViewModelDelegate: ForecastViewModelInputActionsDelegate?
    
    private var countryLabel = UILabel()
    private var cityLabel = UILabel()
    private var dateTimeLabel = UILabel()
    
    private var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = CGSize(width: 140, height: 100)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        return collection
    }()
    
    private var model: WeatherAPIResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastViewModelDelegate = ForecastViewModel(self)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        forecastViewModelDelegate?.getForecast()
    }
}

private extension ForecastViewController {
    func setupUI() {
        countryLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(countryLabel)
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            countryLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            countryLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 16),
        ])
        
        view.addSubview(cityLabel)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8),
            cityLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 16)
        ])
        
        view.addSubview(dateTimeLabel)
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTimeLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        NSLayoutConstraint.activate([
            dateTimeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 6),
            dateTimeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            dateTimeLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 16)
        ])
        
        view.addSubview(mainCollectionView)
        mainCollectionView.dataSource = self
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            // We can use view.safeAreaLayoutGuide.leadingAnchor and view.safeAreaLayoutGuide.trailingAnchor instead of view.leadingAnchor and view.trailingAnchor, but it depends on design
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func reloadForecast() {
        countryLabel.text = model?.location?.country ?? ""
        cityLabel.text = model?.location?.name ?? ""
        dateTimeLabel.text = "Last update: \(model?.location?.localtime ?? "")"
        mainCollectionView.reloadData()
    }
}

extension ForecastViewController: ForecastViewModelOutputActionsDelegate {
    func updateUI(model: WeatherAPIResponseModel) {
        self.model = model
        reloadForecast()
    }
}

extension ForecastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.forecast?.forecastday?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        cell.setup(model: model?.forecast?.forecastday?[indexPath.row])
        return cell
    }
}
