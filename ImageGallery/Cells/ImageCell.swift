//
//  ImageCell.swift
//  ImageGallery
//
//  Created by STL009 on 14/04/19.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        cellImageView.clipsToBounds = true
        cellImageView.layer.cornerRadius = 10
    }
}
