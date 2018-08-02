//
//  PHSlideImagesCollectionViewCell.swift
//  PHSlideImages
//
//  Created by phuongpro Imac on 8/2/18.
//  Copyright © 2018 phuongpro. All rights reserved.
//

import UIKit

class PHSlideImagesCollectionViewCell: UICollectionViewCell {
    var data: PHSlide? {
        didSet {
            guard let slide = data else {
                print("PHSlideImages could not parse the slide you provided. \n\(String(describing: self.data))")
                return
            }
            self.parseData(forSlide: slide)
        }
    }
    
    private lazy var imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        iv.addBlackGradientLayer(frame: self.bounds)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.addSubview(self.imageView)
        NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        if self.descriptionLabel.text != nil && self.titleLabel.text != nil {
            self.addSubview(self.descriptionLabel)
            let left = NSLayoutConstraint(item: descriptionLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15)
            let right = NSLayoutConstraint(item: descriptionLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -15)
            let bottom = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.9, constant: 0)
            let top = NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.25, constant: 0)
            NSLayoutConstraint.activate([left, right, bottom, top])
            
            self.addSubview(self.titleLabel)
            NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15).isActive = true
            NSLayoutConstraint(item: self.titleLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -15).isActive = true
            NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.descriptionLabel, attribute: .top, multiplier: 1.0, constant: 8).isActive = true
            NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 43).isActive = true
            
            self.addConstraintsWithFormat("H:|-15-[v0]-15-|", views: self.titleLabel)
            self.addConstraintsWithFormat("V:[v0(43)]-[v1]", views: self.titleLabel, self.descriptionLabel)
        }
    }
    
    private func parseData(forSlide slide: PHSlide) {
        if let image = slide.image {
            self.imageView.image = image
        }
        
        if let title = slide.title {
            self.titleLabel.text = title
        }
        
        if let description = slide.description {
            self.descriptionLabel.text = description
        }
        
        return
    }
}
