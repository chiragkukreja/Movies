//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Chirag Kukreja on 31/01/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit
import SDWebImage

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configure(with movie: Movie?) {
        if let posterPath = movie?.posterPath {
            guard let url = URL(string: Constant.imgaelogoPath+posterPath) else {return}
            imageView.sd_setImage(with: url,  placeholderImage: UIImage(named: "placeholder.png"))
        } else{
            imageView.image = UIImage(named: "placeholder.png")
        }
    }
}
