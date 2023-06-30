//
//  DetailViewController.swift
//  FilmsList
//
//  Created by Gleb on 29.06.2023.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var selectedFilm: films?
    
    let filmImageView = UIImageView()
    let localizedName = UILabel()
    let yearLabel = UILabel()
    let ratingLabel = UILabel()
    let ratingStringLabel = UILabel()
    let descriptionLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationUI()
    }
    
    //MARK: - Navigation UI
    
    private func setupNavigationUI() {
        
        navigationItem.title = selectedFilm?.name
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hue: 195/360, saturation: 0.83, brightness: 0.16, alpha: 1).cgColor,
            UIColor(hue: 294/360, saturation: 0.78, brightness: 0.21, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.99]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(filmImageView)
        view.addSubview(localizedName)
        view.addSubview(yearLabel)
        view.addSubview(ratingLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(ratingStringLabel)
        
        //MARK: - ImageView Setup
        
        filmImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(130)
            make.width.equalTo(175)
            make.height.equalTo(250)
        }
        
        if let urlString = selectedFilm?.imageURL {
            
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.filmImageView.image = image
                        }
                        
                    }
                }
                
                task.resume()
            }
        }
        
        filmImageView.contentMode = .scaleAspectFill
        filmImageView.layer.cornerRadius = 10
        filmImageView.clipsToBounds = true
        
        //MARK: - Labels Setup
        
        localizedName.snp.makeConstraints { make in
            make.leading.equalTo(filmImageView).inset(200)
            make.top.equalTo(filmImageView)
            make.width.equalTo(150)
        }
        localizedName.numberOfLines = 0
        localizedName.text = selectedFilm?.localizedName
        localizedName.font = UIFont(name: "Kanit-Bold", size: 20)
        localizedName.adjustsFontSizeToFitWidth = true
        localizedName.minimumScaleFactor = 0.8
        localizedName.numberOfLines = 5
        localizedName.textColor = .white
        
        
        yearLabel.snp.makeConstraints { make in
            make.leading.equalTo(localizedName)
            make.top.equalTo(localizedName.snp.bottom).offset(30)
            make.width.equalTo(150)
        }
        yearLabel.numberOfLines = 1
        yearLabel.text = "Год: \(selectedFilm?.year ?? 0)"
        yearLabel.textColor = .white
        yearLabel.font = UIFont(name: "Kanit-Medium", size: 18)
        
        ratingStringLabel.text = "Рейтинг: "
        ratingStringLabel.textColor = .lightGray
        ratingStringLabel.font = UIFont(name: "Kanit-Medium", size: 16)
        ratingStringLabel.snp.makeConstraints { make in
            make.leading.equalTo(filmImageView).inset(200)
            make.top.equalTo(yearLabel).inset(30)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(ratingStringLabel.snp.trailing)
            make.top.equalTo(yearLabel).inset(30)
            
        }
        ratingLabel.numberOfLines = 1
        if let rating = selectedFilm?.rating {
            ratingLabel.text =  "\(rating)"
        } else {
            ratingLabel.text = "Нет рейтинга"
            ratingLabel.textColor = .lightGray
            
        }
        
        ratingLabel.font = UIFont(name: "Kanit-Medium", size: 16)
        if let rating = selectedFilm?.rating {
            switch rating {
            case 7.0...Double.greatestFiniteMagnitude:
                ratingLabel.textColor = UIColor(red: 0.02, green: 0.84, blue: 0.63, alpha: 1.00)
            case 5.0..<7.0:
                ratingLabel.textColor = UIColor(red: 1.00, green: 0.82, blue: 0.40, alpha: 1.00)
            case ..<5.0:
                ratingLabel.textColor = UIColor(red: 0.94, green: 0.28, blue: 0.44, alpha: 1.00)
            default:
                ratingLabel.textColor = .lightGray
            }
            
            
            descriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(filmImageView)
                make.trailing.equalTo(localizedName.snp.trailing)
                make.top.equalTo(filmImageView).inset(270)
                make.height.lessThanOrEqualToSuperview()
                
            }
            if let description = selectedFilm?.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = "Нет описания"
            }
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textColor = .white
            descriptionLabel.textAlignment = .natural
            descriptionLabel.font = UIFont(name: "Kanit-Medium", size: 16)
        }
    }
}


