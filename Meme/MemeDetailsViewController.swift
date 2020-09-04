//
//  MemeDetailsViewController.swift
//  Meme
//
//  Created by Oleksandr Humeniuk on 9/4/20.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    @IBOutlet
    var memeImageView:UIImageView!
    
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = image
    }
}
