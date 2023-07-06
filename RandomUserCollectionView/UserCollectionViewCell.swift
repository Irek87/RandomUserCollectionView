//
//  UserCollectionViewCell.swift
//  RandomUserCollectionView
//
//  Created by Reek i on 05.07.2023.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
