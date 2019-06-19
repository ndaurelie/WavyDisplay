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
            photoImageView.kf.setImage(with: photoUrl)
        }
    }
    
}
