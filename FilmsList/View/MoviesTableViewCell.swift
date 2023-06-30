//
//  MoviesTableViewCell.swift
//  FilmsList
//
//  Created by Gleb on 29.06.2023.
//

import UIKit
import SnapKit

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var localizedLabel: UILabel!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 0
      
        localizedLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
            make.width.equalTo(300)
        }
        
        originalLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(localizedLabel).inset(35)
            make.width.equalTo(300)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(20)
            make.width.equalTo(50)
        }
        
        
        localizedLabel.numberOfLines = 0
        originalLabel.numberOfLines = 0
        
        originalLabel.font = UIFont.systemFont(ofSize: 12)
        localizedLabel.font = UIFont.systemFont(ofSize: 15)
        
        
    }
    
    
}
