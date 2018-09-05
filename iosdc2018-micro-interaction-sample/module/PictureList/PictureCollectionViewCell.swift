//
//  PictureCollectionViewCell.swift
//  iosdc2018-micro-interaction-sample
//
//  Created by kiwi on 2018/08/19.
//  Copyright © 2018年 kiwi26. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!

    var isFavorited = false {
        willSet {
            // true -> false
            if isFavorited && !newValue {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "FavoriteButtonOutlined"), for: .normal)
            }
            
            // false -> true
            if !isFavorited && newValue {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "FavoriteButtonFilled"), for: .normal)
                self.favoriteButton.imageView?.bounds.size = CGSize(width: 36*0.7, height: 36*0.7)
                UIView.animate(withDuration: 0.4, delay: 0.0,
                               // バネの振幅とバネの初速を指定
                               usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0,
                               options: .curveEaseInOut, animations: {
                    self.favoriteButton.imageView?.bounds.size = CGSize(width: 36, height: 36)
                })
            }
        }
    }
    
    var listItem: PictureListItem? {
        didSet {
            if let item = listItem {
                self.titleLabel.text = item.title
                self.pictureImage.image = UIImage(named: item.imageName)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImage.clipsToBounds = true
        pictureImage.layer.cornerRadius = 16
        favoriteButton.clipsToBounds = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonDidTapped), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func favoriteButtonDidTapped () {
        isFavorited = !isFavorited
    }
}
