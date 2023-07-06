//
//  DetailsViewController.swift
//  RandomUserCollectionView
//
//  Created by Reek i on 05.07.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var user: User!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.width/2
        if let user = user {
            configure(with: user)
        }
    }
    
    func configure(with: User) {
        NetworkManager.shared.getUserImage(from: user.picture.large) { image in
            self.imageView.image = image
        }
        
        titleLabel.text = "\(user.name.title). \(user.name.first) \(user.name.last)"
        
        infoTextView.text = """
            Age: \(user.dob.age)
            Gender: \(user.gender)
            Location: \(user.location.city), \(user.location.country)
            E-Mail: \(user.email)
            Phone: \(user.phone)
        """
    }
}
