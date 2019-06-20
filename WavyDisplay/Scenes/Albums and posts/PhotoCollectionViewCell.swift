//
//  PhotoCollectionViewCell.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoUrl: URL! {
        didSet {
            // Show a UIActivityIndicatorView in center of image view while downloading.
            photoImageView.kf.indicatorType = .activity
            
            // Download the image from url, send it to both memory cache and disk cache, and display it in imageView.
            photoImageView.kf.setImage(with: photoUrl)
        }
    }
    
}
