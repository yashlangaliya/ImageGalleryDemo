//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by STL009 on 14/04/19.
//

import UIKit
import SDWebImage
class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        // Do any additional setup after loading the view.
    }

}
