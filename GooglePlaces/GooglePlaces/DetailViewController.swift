//
//  DetailsViewController.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 07/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var place: PlaceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        titleLabel.text = place?.name
        
        if let ref = place?.photos.first?.ref {
            Network.photo(reference: ref) { [weak self] image in
                self?.imageView.image = image
            }
            self.imageView.contentMode = .scaleAspectFill
        } else {
            self.imageView.image = UIImage(named: "nophoto")
            self.imageView.contentMode = .center
        }
        
        let size = CGSize(width: self.view.bounds.width, height: 100)
        scrollView.contentSize = size
        
        let frame = CGRect(origin: .zero, size: size)
        self.view.frame = frame
        
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        self.view.setNeedsDisplay(visibleRect)
        
    }
}
