//
//  CollectionViewCell.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 07/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var place: PlaceModel?
    {
        didSet {
            if let place = place {
                titleLabel.text = place.name
            }
        }
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        super.prepareForReuse()
    }
    
    func setImage(image: UIImage?) {
        
        if let image = image {
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFill
        } else {
            self.imageView.image = UIImage(named: "nophoto")
            self.imageView.contentMode = .center
        }
        
        activity.stopAnimating()
    }
    
}

